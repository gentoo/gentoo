# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit llvm.org

DESCRIPTION="The LLVM linker (link editor) (metapackage)"
HOMEPAGE="https://llvm.org/"

LICENSE="metapackage"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE="debug test zstd"
RESTRICT="test"

RDEPEND="
	~sys-devel/llvm-${PV}[debug?,llvm_projects_lld,test?,zstd?]
"

LLVM_COMPONENTS=()
llvm.org_set_globals
