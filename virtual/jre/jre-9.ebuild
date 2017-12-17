# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for Java Runtime Environment (JRE)"
SLOT="${PV}"
KEYWORDS="~amd64 ~x64-macos ~sparc64-solaris"

RDEPEND="|| (
		virtual/jdk:${SLOT}
		dev-java/oracle-jre-bin:${SLOT}[gentoo-vm(+)]
	)"
