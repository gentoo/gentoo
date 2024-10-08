# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

IUSE="video"

ACCT_USER_ID=250
ACCT_USER_HOME="/var/lib/portage/home"
ACCT_USER_GROUPS=( portage )

acct-user_add_deps

pkg_setup() {
	# https://github.com/gentoo/gentoo/pull/37479
	# allow access to GPUs during tests run
	use video && ACCT_USER_GROUPS+=( video )
}
