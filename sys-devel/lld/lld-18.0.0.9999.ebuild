# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit llvm.org

DESCRIPTION="The LLVM linker (link editor) (metapackage)"
HOMEPAGE="https://llvm.org/"

LICENSE="metapackage"
SLOT="${LLVM_MAJOR}"
KEYWORDS=""
IUSE="+debug zstd"
RESTRICT="test"

RDEPEND="
	~sys-devel/llvm-${PV}:${LLVM_MAJOR}[llvm_projects_lld(-),debug?,zstd?]
"

LLVM_COMPONENTS=( lld )
llvm.org_set_globals
