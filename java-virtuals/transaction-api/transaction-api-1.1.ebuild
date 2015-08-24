# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-virtuals-2

DESCRIPTION="Virtual for Transaction API (javax.transaction)"
HOMEPAGE="https://www.gentoo.org"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="|| (
			dev-java/glassfish-transaction-api:0
			dev-java/jta:0
		)
		"

JAVA_VIRTUAL_PROVIDES="glassfish-transaction-api jta"
