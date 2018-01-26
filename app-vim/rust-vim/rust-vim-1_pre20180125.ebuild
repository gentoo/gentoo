# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vim-plugin vcs-snapshot

MY_PN="${PN/-/.}"
REF="8e75da9834abb22f8d7ece3f4ca4324a14fa18a6"

DESCRIPTION="Vim configuration for Rust"
HOMEPAGE="http://www.rust-lang.org/"
SRC_URI="https://github.com/rust-lang/${MY_PN}/tarball/${REF} -> ${P}.tar.gz"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
