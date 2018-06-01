# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit java-virtuals-2

DESCRIPTION="Virtual ebuilds that require internal com.sun classes from a JDK"
HOMEPAGE="https://www.gentoo.org"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86 ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND="|| (
			dev-java/icedtea-bin:6
			dev-java/icedtea:6
			dev-java/icedtea-bin:7
			dev-java/icedtea:7
			dev-java/oracle-jdk-bin:1.7
			dev-java/oracle-jdk-bin:1.8
			dev-java/apple-jdk-bin:1.6
			dev-java/ibm-jdk-bin:1.6
		)"

JAVA_VIRTUAL_VM="icedtea-bin-6 icedtea6-bin icedtea-6 icedtea6 icedtea-bin-6 icedtea-bin-7 icedtea-7 oracle-jdk-bin-1.7 oracle-jdk-bin-1.8 apple-jdk-bin-1.6 ibm-jdk-bin-1.6"
