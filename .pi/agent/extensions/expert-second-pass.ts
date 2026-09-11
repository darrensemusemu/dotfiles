import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const INSTRUCTION = `EXPERT SECOND-PASS CHECK, THIS IS A MUST
Before making any substantive recommendation, implementation choice, or decision:
1. Do not immediately accept the first plausible approach.
2. Consider how a leading expert in the relevant field would approach it.
3. Compare that expert approach with the initial approach and identify concrete differences.
4. Anticipate the strongest expert criticism of the proposed decision.
5. Revise the decision when that criticism exposes a real weakness.
6. Report the decision-relevant conclusions concisely;`;

export default function (pi: ExtensionAPI) {
	pi.on("before_agent_start", () => ({
		message: {
			customType: "expert-second-pass",
			content: INSTRUCTION,
			display: false,
		},
	}));
}
