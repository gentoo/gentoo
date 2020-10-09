# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A simple password-based encryption utility using scrypt key derivation function"
HOMEPAGE="http://www.tarsnap.com/scrypt.html"
SRC_URI="http://www.tarsnap.com/scrypt/${P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

DOCS=( FORMAT )

src_test() {
	# There's an empty check target, so can't call default.
	emake test
}
