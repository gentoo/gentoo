# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/turbolinks/turbolinks-2.5.3.ebuild,v 1.1 2014/12/28 11:42:44 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

# The gem does not contain runnable tests.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Makes following links in your web application faster"
HOMEPAGE="https://github.com/rails/turbolinks"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "dev-ruby/coffee-rails"
