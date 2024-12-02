# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for Java Runtime Environment (JRE)"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="|| (
		virtual/jdk:${SLOT}
		dev-java/openjdk-jre-bin:${SLOT}[gentoo-vm(+)]
)"
