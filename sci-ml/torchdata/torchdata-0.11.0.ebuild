# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

DESCRIPTION="A repo for data loading and utilities on PyTorch domain libraries."
HOMEPAGE="https://github.com/pytorch/data"
SRC_URI="https://github.com/pytorch/data/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"
S="${WORKDIR}"/data-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	$(python_gen_cond_dep '
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/urllib3[${PYTHON_USEDEP}]
	')
	sci-ml/pytorch[${PYTHON_SINGLE_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/expecttest[${PYTHON_USEDEP}]
		')
	)
"

distutils_enable_tests pytest

src_test() {
	local EPYTEST_DESELECT=(
		test/stateful_dataloader/test_state_dict.py::TestMultiEpochSDL_shard0::test_multi_epoch_sdl_2
		test/stateful_dataloader/test_state_dict.py::TestMultiEpochSDL_shard0::test_multi_epoch_sdl_3
		test/stateful_dataloader/test_state_dict.py::TestEndOfEpochBehavior_shard0::test_end_of_epoch_behavior_2
		test/stateful_dataloader/test_state_dict.py::TestEndOfEpochBehavior_shard0::test_end_of_epoch_behavior_3
		test/stateful_dataloader/test_state_dict.py::TestMultiEpochState_shard0::test_pw
		test/stateful_dataloader/test_state_dict.py::TestSingleIterCalled_shard0::test_mp
		test/stateful_dataloader/test_state_dict.py::TestSingleIterCalled_shard0::test_mp_iter
		test/stateful_dataloader/test_state_dict.py::TestStateInitializationDataset::test_mp
		test/stateful_dataloader/test_state_dict.py::TestOutOfOrderWithCheckpointing::test_out_of_order_index_ds
		test/stateful_dataloader/test_state_dict.py::TestOutOfOrderWithCheckpointing::test_out_of_order_iterable_ds_no_completed_workers
		test/stateful_dataloader/test_state_dict.py::TestOutOfOrderWithCheckpointing::test_out_of_order_iterable_ds_one_completed_worker
	)
	distutils-r1_src_test
}
