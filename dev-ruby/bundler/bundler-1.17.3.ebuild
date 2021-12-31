# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

# The specs require a number of gems to be installed in a temporary
# directory, but this requires network access. They also don't work
# when run with a path that contains "-".
RUBY_FAKEGEM_RECIPE_TEST="none"

# No documentation task
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

RUBY_FAKEGEM_BINDIR="exe"

RUBY_FAKEGEM_EXTRAINSTALL="man"

inherit ruby-fakegem

DESCRIPTION="An easy way to vendor gem dependencies"
HOMEPAGE="https://github.com/carlhuda/bundler"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ~arm arm64 ~hppa ia64 ppc ~ppc64 s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+doc test"

ruby_add_rdepend virtual/rubygems

RDEPEND+=" dev-vcs/git"
