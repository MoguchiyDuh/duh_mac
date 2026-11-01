import { Plugin } from "@opencode/plugin/tui"

const MARKERS = new Set(["agent-switched", "model-switched", "location-switched", "idle"])

export default Plugin.define({
  id: "kirill.rewind",
  setup(context) {
    const currentSession = () => {
      const route = context.ui.router.current()
      return route.type === "session" ? route.sessionID : undefined
    }

    const fail = (message: string) => {
      context.ui.toast.show({ message, variant: "error", duration: 3000 })
    }

    const rewind = async (sessionID: string) => {
      await context.client.session.interrupt({ sessionID })
      await context.client.experimental.session.wait({ sessionID })
      await context.data.session.message.sync(sessionID)
      const messages = context.data.session.message.list(sessionID) ?? []
      const boundary = context.data.session.get(sessionID)?.revert?.messageID
      const end = boundary ? messages.findIndex((message) => message.id === boundary) : -1
      const visible = end === -1 ? messages : messages.slice(0, end)
      const target = visible.findLast((message) => !MARKERS.has(message.type))
      if (!target) return fail("Nothing to rewind")
      if (target.type === "user") return fail("Last entry is a user prompt, use /undo")
      await context.client.session.revert.stage({ sessionID, messageID: target.id, files: false })
    }

    context.keymap.layer(() => ({
      mode: "global",
      commands: [
        {
          id: "rewind.step",
          title: "Rewind last context entry",
          group: "Session",
          bind: "<leader>shift+u",
          palette: true,
          slash: { name: "rewind" },
          run: () => {
            const sessionID = currentSession()
            if (!sessionID) return fail("Open a session first")
            void rewind(sessionID).catch((error) => fail(error instanceof Error ? error.message : String(error)))
          },
        },
      ],
      bindings: ["rewind.step"],
    }))
  },
})
