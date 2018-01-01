# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for Java Development Kit (JDK)"
SLOT="${PV}"
KEYWORDS="~amd64 ~x64-macos ~sparc64-solaris"

RDEPEND="
		dev-java/oracle-jdk-bin:${SLOT}[gentoo-vm(+)]
	"
