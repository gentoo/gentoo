# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/contracts/contracts-0.11.0.ebuild,v 1.1 2015/07/30 06:01:02 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.markdown README.md TODO.markdown TUTORIAL.md"

inherit ruby-fakegem

DESCRIPTION="provides contracts for Ruby"
HOMEPAGE="https://github.com/egonSchiele/contracts.ruby"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~x86"
IUSE=""
