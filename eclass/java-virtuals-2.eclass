# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: java-virtuals-2.eclass
# @MAINTAINER:
# java@gentoo.org
# @AUTHOR:
# Original Author: Alistair John Bush <ali_bush@gentoo.org>
# @BLURB: Java virtuals eclass
# @DESCRIPTION:
# To provide a default (and only) src_install function for ebuilds in the
# java-virtuals category.

inherit java-utils-2

DEPEND=">=dev-java/java-config-2.2.0-r3"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

EXPORT_FUNCTIONS src_install

# @FUNCTION: java-virtuals-2_src_install
# @DESCRIPTION:
# default src_install

java-virtuals-2_src_install() {
	java-virtuals-2_do_write
}

# @FUNCTION: java-pkg_do_virtuals_write
# @INTERNAL
# @DESCRIPTION:
# Writes the virtual env file out to disk.

java-virtuals-2_do_write() {
	java-pkg_init_paths_

	dodir "${JAVA_PKG_VIRTUALS_PATH}"
	{
		if [[ -n "${JAVA_VIRTUAL_PROVIDES}" ]]; then
			echo "PROVIDERS=\"${JAVA_VIRTUAL_PROVIDES}\""
		fi

		if [[ -n "${JAVA_VIRTUAL_VM}" ]]; then
			echo "VM=\"${JAVA_VIRTUAL_VM}\""
		fi

		if [[ -n "${JAVA_VIRTUAL_VM_CLASSPATH}" ]]; then
			echo "VM_CLASSPATH=\"${JAVA_VIRTUAL_VM_CLASSPATH}\""
		fi
		echo "MULTI_PROVIDER=\"${JAVA_VIRTUAL_MULTI=FALSE}\""
	} > "${JAVA_PKG_VIRTUAL_PROVIDER}"
}
