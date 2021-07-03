# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.rdoc"
RUBY_FAKEGEM_EXTRAINSTALL="assets"

inherit ruby-fakegem

DESCRIPTION="Spork is Tim Harper's implementation of test server"
HOMEPAGE="https://github.com/sporkrb/spork"
LICENSE="MIT"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE=""
