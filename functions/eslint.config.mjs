import globals from "globals";
import pluginJs from "@eslint/js";

export default {
  languageOptions: { globals: globals.node },
  ignores: ["node_modules", "venv", "*.py"],
  rules: {
    "indent": ["error", 2],
    "max-len": ["error", 80],
    "no-undef": ["error"],
    "prefer-const": ["error"]
  }
};
