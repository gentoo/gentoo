# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/java-virtuals/transaction-api/transaction-api-1.1.ebuild,v 1.5 2014/12/02 14:28:08 mrueg Exp $

EAPI=5

inherit java-virtuals-2

DESCRIPTION="Virtual for Transaction API (javax.transaction)"
HOMEPAGE="http://www.gentoo.org"
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
