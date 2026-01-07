# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for Java Development Kit (JDK)"
SLOT="${PV}"
#	KEYWORDS="" # Not an LTS candidate
IUSE="headless-awt"

RDEPEND="|| (
		dev-java/openjdk-bin:${SLOT}[gentoo-vm(+),headless-awt=]
		dev-java/openjdk:${SLOT}[gentoo-vm(+),headless-awt=]
)"
