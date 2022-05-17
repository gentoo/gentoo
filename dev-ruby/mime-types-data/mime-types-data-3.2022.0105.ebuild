# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="History.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Registry for information about MIME media type definitions"
HOMEPAGE="https://github.com/mime-types/mime-types-data"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""
