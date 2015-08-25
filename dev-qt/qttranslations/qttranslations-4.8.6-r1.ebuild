# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-build-multilib

DESCRIPTION="Translation files for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS="alpha arm hppa ia64 ppc ppc64"
else
	KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd"
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}
"
RDEPEND=""

QT4_TARGET_DIRECTORIES="translations"

multilib_src_configure() {
	if multilib_is_native_abi; then
		qt4_prepare_env
		qt4_symlink_tools_to_build_dir
		qt4_foreach_target_subdir qt4_qmake
	fi
}

multilib_src_compile() {
	multilib_is_native_abi && qt4_multilib_src_compile
}

multilib_src_test() {
	:
}

multilib_src_install() {
	multilib_is_native_abi && qt4_multilib_src_install
}
