# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""

# Requires every which we don't have packaged.
RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="Modern continuous testing (flexible alternative to Autotest)"
HOMEPAGE="http://mynyml.com/ruby/flexible-continuous-testing"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86 ~x86-macos"
SLOT="0"
IUSE=""

# This is an optional dependency, but highly recommended on unix systems
ruby_add_rdepend "dev-ruby/rev"
