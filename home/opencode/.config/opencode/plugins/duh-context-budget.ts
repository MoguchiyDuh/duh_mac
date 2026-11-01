import { Plugin } from "@opencode/plugin"

const CAP = 250_000
const CAPPED_INPUT = Math.ceil(CAP / 0.9)
const defaultBuffer = (n: number) => Math.max(Math.floor(n * 0.1), n >= 32_000 ? 16_000 : 0)

export default Plugin.define({
  id: "duh-context-budget",
  async setup(ctx) {
    await ctx.model.transform((editor) => {
      for (const model of editor.list()) {
        const native = model.limit.input || model.limit.context
        if (native - defaultBuffer(native) <= CAP) continue
        editor.update(model.providerID, model.id, (draft) => {
          draft.limit.input = CAPPED_INPUT
        })
      }
    })
  },
})
