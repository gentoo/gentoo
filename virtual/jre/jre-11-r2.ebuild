# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for Java Runtime Environment (JRE)"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"

RDEPEND="|| (
		virtual/jdk:${SLOT}
		dev-java/openjdk-jre-bin:${SLOT}[gentoo-vm(+)]
)"
