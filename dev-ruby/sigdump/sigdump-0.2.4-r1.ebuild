# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="ChangeLog README.md"

RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Setup signal handler which dumps backtrace of threads and allocated objects"
HOMEPAGE="https://github.com/frsyuki/sigdump"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""
