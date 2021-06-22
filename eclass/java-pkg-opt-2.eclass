# Copyright 2004-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: java-pkg-opt-2.eclass
# @MAINTAINER:
# java@gentoo.org
# @AUTHOR:
# Thomas Matthijs <axxo@gentoo.org>
# @BLURB: Eclass for package with optional Java support
# @SUPPORTED_EAPIS: 5 6 7
# @DESCRIPTION:
# Inherit this eclass instead of java-pkg-2 if you only need optional Java
# support.

case ${EAPI:-0} in
	[567]) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

EXPORT_FUNCTIONS pkg_setup src_prepare pkg_preinst

if [[ -z ${_JAVA_PKG_OPT_2_ECLASS} ]] ; then
_JAVA_PKG_OPT_2_ECLASS=1

inherit java-utils-2

# @ECLASS-VARIABLE: JAVA_PKG_OPT_USE
# @DESCRIPTION:
# USE flag to control if optional Java stuff is build. Defaults to 'java'.
JAVA_PKG_OPT_USE=${JAVA_PKG_OPT_USE:-java}

DEPEND="${JAVA_PKG_OPT_USE}? ( ${JAVA_PKG_E_DEPEND} )"
RDEPEND="${DEPEND}"

# See java-pkg-2.eclass for JAVA_PKG_IUSE documentation
IUSE="${JAVA_PKG_IUSE} ${JAVA_PKG_OPT_USE}"

# @FUNCTION: java-pkg-opt-2_pkg_setup
# @DESCRIPTION:
# default pkg_setup, wrapper for java-utils-2_pkg_init

java-pkg-opt-2_pkg_setup() {
	use ${JAVA_PKG_OPT_USE} && java-pkg_init
}


# @FUNCTION: java-pkg-opt-2_src_prepare
# @DESCRIPTION:
# default src_prepare, wrapper for java-utils-2_src_prepare

java-pkg-opt-2_src_prepare() {
	use ${JAVA_PKG_OPT_USE} && java-utils-2_src_prepare
	case "${EAPI:-0}" in
		[0-5]) ;;
		*) use ${JAVA_PKG_OPT_USE} || eapply_user ;;
	esac
}


# @FUNCTION: java-pkg-opt-2_pkg_preinst
# @DESCRIPTION:
# default pkg_preinst, wrapper for java-utils-2_pkg_preinst

java-pkg-opt-2_pkg_preinst() {
	use ${JAVA_PKG_OPT_USE} && java-utils-2_pkg_preinst
}

fi
