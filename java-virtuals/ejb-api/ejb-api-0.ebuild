# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-virtuals-2

DESCRIPTION="Virtual for Enterprise JavaBeans API (javax.ejb)"
HOMEPAGE="https://www.gentoo.org"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="dev-java/glassfish-ejb-api:0"

JAVA_VIRTUAL_PROVIDES="glassfish-ejb-api"
