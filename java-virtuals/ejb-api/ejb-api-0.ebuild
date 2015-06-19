# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/java-virtuals/ejb-api/ejb-api-0.ebuild,v 1.1 2013/10/23 17:49:48 tomwij Exp $

EAPI="5"

inherit java-virtuals-2

DESCRIPTION="Virtual for Enterprise JavaBeans API (javax.ejb)"
HOMEPAGE="http://www.gentoo.org"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="dev-java/glassfish-ejb-api:0"

JAVA_VIRTUAL_PROVIDES="glassfish-ejb-api"
