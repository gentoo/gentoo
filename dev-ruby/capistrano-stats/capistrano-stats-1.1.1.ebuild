# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRAINSTALL="tasks"

inherit ruby-fakegem

DESCRIPTION="Official metrics to help the development direction of Capistrano"
HOMEPAGE="http://metrics.capistranorb.com/"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64"
IUSE=""
