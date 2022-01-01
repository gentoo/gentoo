# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Apply default POSIX ACLs to files and directories"
HOMEPAGE="http://michael.orlitzky.com/code/apply-default-acl.xhtml"
SRC_URI="http://michael.orlitzky.com/code/releases/${P}.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-apps/acl"
RDEPEND="${DEPEND}"

DOCS=( doc/README )

# tests need to be executed on filesystem with ACL support
# skipping them for now
RESTRICT="test"

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
