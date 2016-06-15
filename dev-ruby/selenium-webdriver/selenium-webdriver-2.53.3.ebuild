# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

# NOTE: this package contains precompiled code. It appears that all
# source code can be found at https://code.google.com/p/selenium/ but the
# repository is not organized in a way so that we can easily rebuild the
# suited shared object. We'll just try our luck with the precompiled
# objects for now.

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES README.md"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_QA_ALLOWED_LIBS="x_ignore_nofocus.so"
QA_PREBUILT="*/x_ignore_nofocus.so"

inherit ruby-fakegem

DESCRIPTION="This gem provides Ruby bindings for WebDriver"
HOMEPAGE="http://gemcutter.org/gems/selenium-webdriver"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/childprocess-0.5.0
	dev-ruby/rubyzip:1"

all_ruby_prepare() {
	# Make websocket a development dependency since it is only needed
	# for the safari driver which we don't support on Gentoo.
	sed -i -e '/websocket/,/version_requirements/ s/runtime/development/' ../metadata || die
}
