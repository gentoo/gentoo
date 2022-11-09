# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="AUTHORS ChangeLog NEWS README.md"

inherit ruby-fakegem

DESCRIPTION="Sorts an array in column order"
HOMEPAGE="https://github.com/rocky/columnize"

LICENSE="|| ( GPL-2 Ruby )"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE=""
