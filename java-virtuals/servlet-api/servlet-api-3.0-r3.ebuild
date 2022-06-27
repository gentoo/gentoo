# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-virtuals-2

DESCRIPTION="Virtual for servlet api"
HOMEPAGE="https://jcp.org/en/jsr/detail?id=340"

LICENSE="public-domain"
SLOT="${PV}"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux"

RDEPEND="|| (
		dev-java/tomcat-servlet-api:${SLOT}
		dev-java/resin-servlet-api:${SLOT}
	)"

JAVA_VIRTUAL_PROVIDES="tomcat-servlet-api-${SLOT} resin-servlet-api-${SLOT}"
