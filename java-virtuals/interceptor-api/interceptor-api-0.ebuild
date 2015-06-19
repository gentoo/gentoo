# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/java-virtuals/interceptor-api/interceptor-api-0.ebuild,v 1.4 2015/06/14 17:56:07 monsieurp Exp $

EAPI="5"

inherit java-virtuals-2

DESCRIPTION="Virtual for Interceptor API (javax.interceptor)"
HOMEPAGE="http://www.gentoo.org"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="dev-java/glassfish-interceptor-api:0"

JAVA_VIRTUAL_PROVIDES="glassfish-interceptor-api"
