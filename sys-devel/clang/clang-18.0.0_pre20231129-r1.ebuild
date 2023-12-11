# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit llvm.org

DESCRIPTION="C language family frontend for LLVM (metapackage)"
HOMEPAGE="https://llvm.org/"

LICENSE="metapackage"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE="debug doc +extra ieee-long-double +pie +static-analyzer test xml"
RESTRICT="test"

RDEPEND="
	~sys-devel/llvm-${PV}[debug?,doc?,ieee-long-double?,llvm_projects_clang,pie?,static-analyzer?,test?,xml?]
	>=sys-devel/llvm-18.0.0_pre20231129-r1
	extra? ( ~sys-devel/llvm-${PV}[llvm_projects_clang-tools-extra] )
"

LLVM_COMPONENTS=()
LLVM_USE_TARGETS=llvm
llvm.org_set_globals
