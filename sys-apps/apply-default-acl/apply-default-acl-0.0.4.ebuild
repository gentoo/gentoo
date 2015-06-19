# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/apply-default-acl/apply-default-acl-0.0.4.ebuild,v 1.3 2013/02/16 22:38:31 ago Exp $

EAPI=5

DESCRIPTION="Apply default POSIX ACLs to files and directories"
HOMEPAGE="http://michael.orlitzky.com/code/apply-default-acl.php"
SRC_URI="http://michael.orlitzky.com/code/releases/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="sys-apps/acl"
RDEPEND="${DEPEND}"

DOCS=( doc/README )

# tests need to be executed on filesystem with ACL support
# skipping them for now
RESTRICT="test"
