# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

# The testsuite is not in the Gem, only in the upstream repo.
RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="docs/*.md README.md"

inherit ruby-fakegem

DESCRIPTION="IRC Bot Building Framework"
HOMEPAGE="https://github.com/cinchrb/cinch http://cinchrb.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
