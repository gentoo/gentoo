# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

# Use rdoc recipe to avoid obsolete Rakefile
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CONTRIBUTION_GUIDELINES.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Making tests easy on the fingers and eyes"
HOMEPAGE="http://thoughtbot.com/projects/shoulda"
SRC_URI="https://github.com/thoughtbot/${PN}/tarball/v${PV} -> ${P}.tar.gz"
RUBY_S="thoughtbot-${PN}-*"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

# tests seem to be quite broken :( They require working version of
# various rails versions. There appear to be unit and matcher tests but
# they can't be run on their own.
RESTRICT=test
