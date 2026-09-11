import { isToolCallEventType, type ExtensionAPI } from "@earendil-works/pi-coding-agent";

const APPROVE_ONCE = "Approve once";
const APPROVE_ALL = "Approve all bash calls for this session";
const REJECT = "Reject";

export default function (pi: ExtensionAPI) {
	let approveAll = false;

	pi.on("tool_call", async (event, ctx) => {
		if (!isToolCallEventType("bash", event) || approveAll) return undefined;

		if (!ctx.hasUI) {
			return {
				block: true,
				reason: "Bash command requires approval, but no approval UI is available",
			};
		}

		const choice = await ctx.ui.select(
			`Approve bash command?\n\n${event.input.command}`,
			[APPROVE_ONCE, APPROVE_ALL, REJECT],
		);

		if (choice === APPROVE_ALL) {
			approveAll = true;
			return undefined;
		}

		if (choice === APPROVE_ONCE) return undefined;

		return { block: true, reason: "Bash command rejected by user" };
	});
}
