// SPDX-License-Identifier: Apache-2.0

#include "sharkdash.hpp"

#include <iterator>
#include <ranges>
#include <string_view>
#include <vector>

auto main(int argc, const char* argv[]) -> int {
	std::vector<std::string_view> args;
	args.reserve(static_cast<size_t>(argc > 0 ? argc - 1 : 0));
	for (auto arg : std::views::counted(std::next(argv), argc - 1)) {
		args.emplace_back(arg);
	}
	return sharkdash_main(std::move(args));
}
