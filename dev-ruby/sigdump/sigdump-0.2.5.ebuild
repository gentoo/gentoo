# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="ChangeLog README.md"

RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Setup signal handler which dumps backtrace of threads and allocated objects"
HOMEPAGE="https://github.com/fluent/sigdump"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64"
