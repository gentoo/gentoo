# Eclass for optional Java packages
#
# Copyright (c) 2004-2005, Thomas Matthijs <axxo@gentoo.org>
# Copyright (c) 2004-2011, Gentoo Foundation
#
# Licensed under the GNU General Public License, v2
#
# Major changes:
#    20070805:
#       Removed phase hooks because Portage does proper env saving now.
#       <betelgeuse@gentoo.org>
#
# $Header: /var/cvsroot/gentoo-x86/eclass/java-pkg-opt-2.eclass,v 1.16 2012/07/21 12:00:17 sera Exp $

# @ECLASS: java-pkg-opt-2.eclass
# @MAINTAINER:
# java@gentoo.org
# @AUTHOR:
# Thomas Matthijs <axxo@gentoo.org>
# @BLURB: Eclass for package with optional Java support
# @DESCRIPTION:
# Inherit this eclass instead of java-pkg-2 if you only need optional Java
# support.

inherit java-utils-2

# @ECLASS-VARIABLE: JAVA_PKG_OPT_USE
# @DESCRIPTION:
# USE flag to control if optional Java stuff is build. Defaults to 'java'.
JAVA_PKG_OPT_USE=${JAVA_PKG_OPT_USE:-java}

DEPEND="${JAVA_PKG_OPT_USE}? ( ${JAVA_PKG_E_DEPEND} )"
RDEPEND="${DEPEND}"

# See java-pkg-2.eclass for JAVA_PKG_IUSE documentation
IUSE="${JAVA_PKG_IUSE} ${JAVA_PKG_OPT_USE}"

case "${EAPI:-0}" in
	0|1) EXPORT_FUNCTIONS pkg_setup pkg_preinst ;;
	*) EXPORT_FUNCTIONS pkg_setup src_prepare pkg_preinst ;;
esac

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
}


# @FUNCTION: java-pkg-opt-2_pkg_preinst
# @DESCRIPTION:
# default pkg_preinst, wrapper for java-utils-2_pkg_preinst

java-pkg-opt-2_pkg_preinst() {
	use ${JAVA_PKG_OPT_USE} && java-utils-2_pkg_preinst
}
