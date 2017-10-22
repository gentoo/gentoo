# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Virtual for Java Development Kit (JDK)"
SLOT="1.9"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc64-solaris ~x64-solaris"

# needs to be prepended by the following once icedtea{,-bin}:9 have been
# introduced
#		dev-java/icedtea-bin:9
#		dev-java/icedtea:9
RDEPEND="|| (
		dev-java/oracle-jdk-bin:1.9
	)"
