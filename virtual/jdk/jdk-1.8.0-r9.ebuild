# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for Java Development Kit (JDK)"
SLOT="1.8"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~x64-macos ~x64-solaris"
IUSE="headless-awt"

RDEPEND="|| (
		dev-java/openjdk-bin:8[headless-awt=]
		dev-java/openjdk:8[headless-awt=]
)"
