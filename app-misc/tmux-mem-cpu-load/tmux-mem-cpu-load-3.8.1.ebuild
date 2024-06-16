# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/thewtex/tmux-mem-cpu-load.git"
	inherit git-r3
else
	SRC_URI="https://github.com/thewtex/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="CPU, RAM memory, and load monitor for use with tmux"
HOMEPAGE="https://github.com/thewtex/tmux-mem-cpu-load"

LICENSE="Apache-2.0"
SLOT="0"

DOCS=( AUTHORS README.rst )
