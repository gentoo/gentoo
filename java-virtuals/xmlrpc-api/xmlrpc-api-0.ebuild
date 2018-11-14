# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit java-virtuals-2

DESCRIPTION="Virtual for XML RPC API (javax.xml.rpc)"
HOMEPAGE="https://www.gentoo.org"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="dev-java/glassfish-xmlrpc-api:0"

JAVA_VIRTUAL_PROVIDES="glassfish-xmlrpc-api"
