# Copyright 2004-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: java-pkg-2.eclass
# @MAINTAINER:
# java@gentoo.org
# @AUTHOR:
# Thomas Matthijs <axxo@gentoo.org>
# @SUPPORTED_EAPIS: 8 9
# @PROVIDES: java-utils-2
# @BLURB: Eclass for Java Packages
# @DESCRIPTION:
# This eclass should be inherited for pure Java packages, or by packages which
# need to use Java.

if [[ -z ${_JAVA_PKG_2_ECLASS} ]] ; then
_JAVA_PKG_2_ECLASS=1

case ${EAPI} in
	8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit java-utils-2

# @ECLASS_VARIABLE: JAVA_PKG_IUSE
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Use JAVA_PKG_IUSE instead of IUSE for doc, source and examples so that
# the eclass can automatically add the needed dependencies for the java-pkg_do*
# functions.
IUSE="${JAVA_PKG_IUSE}"

# Java packages need java-config, and a fairly new release of Portage.
# JAVA_PKG_E_DEPEND is defined in java-utils.eclass.
DEPEND="${JAVA_PKG_E_DEPEND}"

# Nothing special for RDEPEND... just the same as DEPEND.
RDEPEND="${DEPEND}"


# @FUNCTION: java-pkg-2_pkg_setup
# @DESCRIPTION:
# pkg_setup initializes the Java environment
java-pkg-2_pkg_setup() {
	java-pkg_init
}


# @FUNCTION: java-pkg-2_src_prepare
# @DESCRIPTION:
# wrapper for java-utils-2_src_prepare
java-pkg-2_src_prepare() {
	java-utils-2_src_prepare
}

# @FUNCTION: java-pkg-2_pkg_preinst
# @DESCRIPTION:
# wrapper for java-utils-2_pkg_preinst
java-pkg-2_pkg_preinst() {
	java-utils-2_pkg_preinst
}

fi

EXPORT_FUNCTIONS pkg_setup src_prepare pkg_preinst
