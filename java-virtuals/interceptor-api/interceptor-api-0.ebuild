# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-virtuals-2

DESCRIPTION="Virtual for Interceptor API (javax.interceptor)"
HOMEPAGE="https://www.gentoo.org"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="dev-java/glassfish-interceptor-api:0"

JAVA_VIRTUAL_PROVIDES="glassfish-interceptor-api"
