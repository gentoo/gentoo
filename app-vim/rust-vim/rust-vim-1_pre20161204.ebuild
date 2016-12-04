# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin vcs-snapshot

MY_PN="${PN/-/.}"
REF="eed97e75117faaf210cb6103cf39a797fe21bfbe"

DESCRIPTION="Vim configuration for Rust"
HOMEPAGE="http://www.rust-lang.org/"
SRC_URI="https://github.com/rust-lang/${MY_PN}/tarball/${REF} -> ${P}.tar.gz"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
