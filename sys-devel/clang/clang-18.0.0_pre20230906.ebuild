# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit llvm.org

DESCRIPTION="C language family frontend for LLVM (metapackage)"
HOMEPAGE="https://llvm.org/"

LICENSE="metapackage"
SLOT="${LLVM_MAJOR}"
KEYWORDS=""
IUSE="+debug doc +extra ieee-long-double +pie +static-analyzer xml"
RESTRICT="test"

RDEPEND="
	~sys-devel/llvm-${PV}:${LLVM_MAJOR}[llvm_projects_clang(-),debug?,doc?,ieee-long-double?,pie?,static-analyzer?,xml?]
	extra? (
		~sys-devel/llvm-${PV}:${LLVM_MAJOR}[llvm_projects_clang-tools-extra(-)]
	)
"

LLVM_COMPONENTS=( clang )
LLVM_USE_TARGETS=llvm
llvm.org_set_globals
