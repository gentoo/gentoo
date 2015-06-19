# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/apple-jdk-bin/apple-jdk-bin-1.6.0.ebuild,v 1.5 2012/11/27 07:54:39 grobian Exp $

JAVA_SUPPORTS_GENERATION_1="true"
inherit java-vm-2 eutils

DESCRIPTION="Links to Apple's version of Sun's J2SE Development Kit"
HOMEPAGE="http://java.sun.com/j2se/1.6.0/"
SLOT="1.6"
LICENSE="public-domain"
KEYWORDS="-* ~x64-macos ~x86-macos"
IUSE=""

JAVA_PROVIDE="jdbc-stdext"

APPLE_JAVA_DIR="/System/Library/Frameworks/JavaVM.framework/Versions/${PV}/Home"

pkg_preinst() {
	[[ ! -d ${APPLE_JAVA_DIR} ]] && die "Java 6 not installed!"
}

src_install() {
	local dirs="bin include lib man"
	dodir /opt/${P}

	for d in ${dirs}; do
		ln -s "${APPLE_JAVA_DIR}"/${d} "${ED}"/opt/${P}/${d}
	done
	# Apple just puts al JRE stuff in the Home dir next to the JDK stuff,
	# "emulate" it to make the wrappers happy
	ln -s "${APPLE_JAVA_DIR}" "${ED}"/opt/${P}/jre

	# create dir for system preferences
	dodir /opt/${P}/.systemPrefs
	# Create files used as storage for system preferences.
	touch "${ED}/opt/${P}/.systemPrefs/.system.lock"
	chmod 644 "${ED}/opt/${P}/.systemPrefs/.system.lock"
	touch "${ED}/opt/${P}/.systemPrefs/.systemRootModFile"
	chmod 644 "${ED}/opt/${P}/.systemPrefs/.systemRootModFile"

	set_java_env
}

pkg_postinst() {
	# Set as default VM if none exists
	java-vm-2_pkg_postinst

	elog "Note: you're using your OSX (pre-)installed Java installation"
}
