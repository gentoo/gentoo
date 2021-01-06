# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for Java Development Kit (JDK)"
SLOT="1.8"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc64-solaris ~x64-solaris"

RDEPEND="|| (
		dev-java/openjdk-bin:8
		dev-java/openjdk:8
		dev-java/icedtea-bin:8
		dev-java/icedtea:8
)"
