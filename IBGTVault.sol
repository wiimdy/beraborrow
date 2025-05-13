// SPDX-License-Identifier: MIT
pragma solidity =0.8.26 ^0.8.0 ^0.8.1 ^0.8.20 ^0.8.21;

// lib/openzeppelin-contracts/contracts/utils/Address.sol

// OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

// lib/openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol

// OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
// This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 *
 * [WARNING]
 * ====
 * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
 * unusable.
 * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
 *
 * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
 * array of EnumerableSet.
 * ====
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping(bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes32 lastValue = set._values[lastIndex];

                // Move the last value to the index where the value to delete is
                set._values[toDeleteIndex] = lastValue;
                // Update the index for the moved value
                set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
        bytes32[] memory store = _values(set._inner);
        bytes32[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(AddressSet storage set) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(UintSet storage set) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }
}

// lib/openzeppelin-contracts/contracts/proxy/beacon/IBeacon.sol

// OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)

/**
 * @dev This is the interface that {BeaconProxy} expects of its beacon.
 */
interface IBeacon {
    /**
     * @dev Must return an address that can be used as a delegate call target.
     *
     * {BeaconProxy} will check that this address is a contract.
     */
    function implementation() external view returns (address);
}

// lib/openzeppelin-contracts/contracts/interfaces/IERC1967.sol

// OpenZeppelin Contracts (last updated v5.0.0) (interfaces/IERC1967.sol)

/**
 * @dev ERC-1967: Proxy Storage Slots. This interface contains the events defined in the ERC.
 */
interface IERC1967 {
    /**
     * @dev Emitted when the implementation is upgraded.
     */
    event Upgraded(address indexed implementation);

    /**
     * @dev Emitted when the admin account has changed.
     */
    event AdminChanged(address previousAdmin, address newAdmin);

    /**
     * @dev Emitted when the beacon is changed.
     */
    event BeaconUpgraded(address indexed beacon);
}

// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol

// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// lib/openzeppelin-contracts/contracts/interfaces/IERC3156FlashBorrower.sol

// OpenZeppelin Contracts (last updated v4.7.0) (interfaces/IERC3156FlashBorrower.sol)

/**
 * @dev Interface of the ERC3156 FlashBorrower, as defined in
 * https://eips.ethereum.org/EIPS/eip-3156[ERC-3156].
 *
 * _Available since v4.1._
 */
interface IERC3156FlashBorrower {
    /**
     * @dev Receive a flash loan.
     * @param initiator The initiator of the loan.
     * @param token The loan currency.
     * @param amount The amount of tokens lent.
     * @param fee The additional amount of tokens to repay.
     * @param data Arbitrary data structure, intended to contain user-defined parameters.
     * @return The keccak256 hash of "IERC3156FlashBorrower.onFlashLoan"
     */
    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32);
}

// src/interfaces/core/IFactory.sol

interface IFactory {
    // commented values are suggested default parameters
    struct DeploymentParams {
        uint256 minuteDecayFactor; // 999037758833783000  (half life of 12 hours)
        uint256 redemptionFeeFloor; // 1e18 / 1000 * 5  (0.5%)
        uint256 maxRedemptionFee; // 1e18  (100%)
        uint256 borrowingFeeFloor; // 1e18 / 1000 * 5  (0.5%)
        uint256 maxBorrowingFee; // 1e18 / 100 * 5  (5%)
        uint256 interestRateInBps; // 100 (1%)
        uint256 maxDebt;
        uint256 MCR; // 12 * 1e17  (120%)
        address collVaultRouter; // set to address(0) if DenManager coll is not CollateralVault
    }

    event NewDeployment(address collateral, address priceFeed, address denManager, address sortedDens);

    function deployNewInstance(
        address collateral,
        address priceFeed,
        address customDenManagerImpl,
        address customSortedDensImpl,
        DeploymentParams calldata params,
        uint64 unlockRatePerSecond,
        bool forceThroughLspBalanceCheck
    ) external;

    function setImplementations(address _denManagerImpl, address _sortedDensImpl) external;

    function BERABORROW_CORE() external view returns (address);

    function borrowerOperations() external view returns (address);

    function debtToken() external view returns (address);

    function guardian() external view returns (address);

    function liquidationManager() external view returns (address);

    function owner() external view returns (address);

    function sortedDensImpl() external view returns (address);

    function liquidStabilityPool() external view returns (address);

    function denManagerCount() external view returns (uint256);

    function denManagerImpl() external view returns (address);

    function denManagers(uint256) external view returns (address);
}

// src/interfaces/utils/integrations/IInfraredVault.sol

interface IInfraredVault {
    function stakingToken() external view returns (address);
    function stake(uint256 amount) external;
    function withdraw(uint256 amount) external;
    function getReward() external;
    function getRewardForUser(address account) external;
    function rewardTokens(uint) external view returns (address);
    function getAllRewardTokens() external view returns (address[] memory);
    function earned(address account, address _rewardsToken) external view returns (uint256);
    function registerVault(address stakingToken) external returns (address);
}

// src/interfaces/core/IMetaBeraborrowCore.sol

interface IMetaBeraborrowCore {
    // ---------------------------------
    // Structures
    // ---------------------------------
    struct FeeInfo {
        bool existsForNect;
        uint16 nectFee;
    }

    struct RebalancerFeeInfo {
        bool exists;
        uint16 entryFee;
        uint16 exitFee;
    }

    // ---------------------------------
    // Public constants
    // ---------------------------------
    function OWNERSHIP_TRANSFER_DELAY() external view returns (uint256);
    function DEFAULT_FLASH_LOAN_FEE() external view returns (uint16);

    // ---------------------------------
    // Public state variables
    // ---------------------------------
    function nect() external view returns (address);
    function lspEntryFee() external view returns (uint16);
    function lspExitFee() external view returns (uint16);

    function feeReceiver() external view returns (address);
    function priceFeed() external view returns (address);
    function owner() external view returns (address);
    function pendingOwner() external view returns (address);
    function ownershipTransferDeadline() external view returns (uint256);
    function manager() external view returns (address);
    function guardian() external view returns (address);
    function paused() external view returns (bool);
    function lspBootstrapPeriod() external view returns (uint64);

    // ---------------------------------
    // External functions
    // ---------------------------------
    function setFeeReceiver(address _feeReceiver) external;
    function setPriceFeed(address _priceFeed) external;
    function setGuardian(address _guardian) external;
    function setManager(address _manager) external;

    /**
     * @notice Global pause/unpause
     *         Pausing halts new deposits/borrowing across the protocol
     */
    function setPaused(bool _paused) external;

    /**
     * @notice Extend or change the LSP bootstrap period,
     *         after which certain protocol mechanics change
     */
    function setLspBootstrapPeriod(uint64 _bootstrapPeriod) external;

    /**
     * @notice Set a custom flash-loan fee for a given periphery contract
     * @param _periphery Target contract that will get this custom fee
     * @param _nectFee Fee in basis points (bp)
     * @param _existsForNect Whether this custom fee is used when the caller = `nect`
     */
    function setPeripheryFlashLoanFee(address _periphery, uint16 _nectFee, bool _existsForNect) external;

    /**
     * @notice Begin the ownership transfer process
     * @param newOwner The address proposed to be the new owner
     */
    function commitTransferOwnership(address newOwner) external;

    /**
     * @notice Finish the ownership transfer, after the mandatory delay
     */
    function acceptTransferOwnership() external;

    /**
     * @notice Revoke a pending ownership transfer
     */
    function revokeTransferOwnership() external;

    /**
     * @notice Look up a custom flash-loan fee for a specific periphery contract
     * @param peripheryContract The contract that might have a custom fee
     * @return The flash-loan fee in basis points
     */
    function getPeripheryFlashLoanFee(address peripheryContract) external view returns (uint16);

    /**
     * @notice Set / override entry & exit fees for a special rebalancer contract
     */
    function setRebalancerFee(address _rebalancer, uint16 _entryFee, uint16 _exitFee) external;

    /**
     * @notice Set the LSP entry fee globally
     * @param _fee Fee in basis points
     */
    function setEntryFee(uint16 _fee) external;

    /**
     * @notice Set the LSP exit fee globally
     * @param _fee Fee in basis points
     */
    function setExitFee(uint16 _fee) external;

    /**
     * @notice Look up the LSP entry fee for a rebalancer
     * @param rebalancer Possibly has a special fee
     * @return The entry fee in basis points
     */
    function getLspEntryFee(address rebalancer) external view returns (uint16);

    /**
     * @notice Look up the LSP exit fee for a rebalancer
     * @param rebalancer Possibly has a special fee
     * @return The exit fee in basis points
     */
    function getLspExitFee(address rebalancer) external view returns (uint16);

    // ---------------------------------
    // Events
    // ---------------------------------
    event NewOwnerCommitted(address indexed owner, address indexed pendingOwner, uint256 deadline);
    event NewOwnerAccepted(address indexed oldOwner, address indexed newOwner);
    event NewOwnerRevoked(address indexed owner, address indexed revokedOwner);

    event FeeReceiverSet(address indexed feeReceiver);
    event PriceFeedSet(address indexed priceFeed);
    event GuardianSet(address indexed guardian);
    event ManagerSet(address indexed manager);
    event PeripheryFlashLoanFee(address indexed periphery, uint16 nectFee);
    event LSPBootstrapPeriodSet(uint64 bootstrapPeriod);
    event RebalancerFees(address indexed rebalancer, uint16 entryFee, uint16 exitFee);
    event EntryFeeSet(uint16 fee);
    event ExitFeeSet(uint16 fee);
    event Paused();
    event Unpaused();
}

// src/interfaces/core/IPriceFeed.sol

interface IPriceFeed {
    struct FeedType {
        address spotOracle;
        bool isCollVault;
    }

    event NewOracleRegistered(address token, address chainlinkAggregator, address underlyingDerivative);
    event PriceFeedStatusUpdated(address token, address oracle, bool isWorking);
    event PriceRecordUpdated(address indexed token, uint256 _price);
    event NewCollVaultRegistered(address collVault, bool enable);
    event NewSpotOracleRegistered(address token, address spotOracle);

    function fetchPrice(address _token) external view returns (uint256);

    function getMultiplePrices(address[] memory _tokens) external view returns (uint256[] memory prices);

    function setOracle(
        address _token,
        address _chainlinkOracle,
        uint32 _heartbeat,
        uint16 _staleThreshold,
        address underlyingDerivative
    ) external;

    function whitelistCollateralVault(address _collateralVaultShareToken, bool enable) external;
    
    function setSpotOracle(address _token, address _spotOracle) external;
    
    function MAX_PRICE_DEVIATION_FROM_PREVIOUS_ROUND() external view returns (uint256);

    function BERABORROW_CORE() external view returns (address);

    function RESPONSE_TIMEOUT() external view returns (uint256);

    function TARGET_DIGITS() external view returns (uint256);

    function guardian() external view returns (address);

    function oracleRecords(
        address
    )
        external
        view
        returns (
        address chainLinkOracle,
        uint8 decimals,
        uint32 heartbeat,
        uint16 staleThreshold,
        address underlyingDerivative
    );

    function isCollVault(address _collateralVaultShareToken) external view returns (bool);

    function isStableBPT(address _oracle) external view returns (bool);

    function isWeightedBPT(address _oracle) external view returns (bool);

    function getSpotOracle(address _token) external view returns (address);

    function feedType(address _token) external view returns (FeedType memory);

    function owner() external view returns (address);
}

// src/interfaces/utils/integrations/IRebalancer.sol

interface IRebalancer {
    function swap(
        address sentCurrency,
        uint sentAmount,
        address receivedCurrency,
        bytes calldata payload
    ) external;
}

// lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (proxy/utils/Initializable.sol)

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 * case an upgrade adds a module that needs to be initialized.
 *
 * For example:
 *
 * [.hljs-theme-light.nopadding]
 * ```solidity
 * contract MyToken is ERC20Upgradeable {
 *     function initialize() initializer public {
 *         __ERC20_init("MyToken", "MTK");
 *     }
 * }
 *
 * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
 *     function initializeV2() reinitializer(2) public {
 *         __ERC20Permit_init("MyToken");
 *     }
 * }
 * ```
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() {
 *     _disableInitializers();
 * }
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Storage of the initializable contract.
     *
     * It's implemented on a custom ERC-7201 namespace to reduce the risk of storage collisions
     * when using with upgradeable contracts.
     *
     * @custom:storage-location erc7201:openzeppelin.storage.Initializable
     */
    struct InitializableStorage {
        /**
         * @dev Indicates that the contract has been initialized.
         */
        uint64 _initialized;
        /**
         * @dev Indicates that the contract is in the process of being initialized.
         */
        bool _initializing;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.Initializable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant INITIALIZABLE_STORAGE = 0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00;

    /**
     * @dev The contract is already initialized.
     */
    error InvalidInitialization();

    /**
     * @dev The contract is not initializing.
     */
    error NotInitializing();

    /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint64 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts.
     *
     * Similar to `reinitializer(1)`, except that in the context of a constructor an `initializer` may be invoked any
     * number of times. This behavior in the constructor can be useful during testing and is not expected to be used in
     * production.
     *
     * Emits an {Initialized} event.
     */
    modifier initializer() {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        // Cache values to avoid duplicated sloads
        bool isTopLevelCall = !$._initializing;
        uint64 initialized = $._initialized;

        // Allowed calls:
        // - initialSetup: the contract is not in the initializing state and no previous version was
        //                 initialized
        // - construction: the contract is initialized at version 1 (no reininitialization) and the
        //                 current contract is just being deployed
        bool initialSetup = initialized == 0 && isTopLevelCall;
        bool construction = initialized == 1 && address(this).code.length == 0;

        if (!initialSetup && !construction) {
            revert InvalidInitialization();
        }
        $._initialized = 1;
        if (isTopLevelCall) {
            $._initializing = true;
        }
        _;
        if (isTopLevelCall) {
            $._initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * A reinitializer may be used after the original initialization step. This is essential to configure modules that
     * are added through upgrades and that require initialization.
     *
     * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
     * cannot be nested. If one is invoked in the context of another, execution will revert.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     *
     * WARNING: Setting the version to 2**64 - 1 will prevent any future reinitialization.
     *
     * Emits an {Initialized} event.
     */
    modifier reinitializer(uint64 version) {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        if ($._initializing || $._initialized >= version) {
            revert InvalidInitialization();
        }
        $._initialized = version;
        $._initializing = true;
        _;
        $._initializing = false;
        emit Initialized(version);
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        _checkInitializing();
        _;
    }

    /**
     * @dev Reverts if the contract is not in an initializing state. See {onlyInitializing}.
     */
    function _checkInitializing() internal view virtual {
        if (!_isInitializing()) {
            revert NotInitializing();
        }
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     *
     * Emits an {Initialized} event the first time it is successfully executed.
     */
    function _disableInitializers() internal virtual {
        // solhint-disable-next-line var-name-mixedcase
        InitializableStorage storage $ = _getInitializableStorage();

        if ($._initializing) {
            revert InvalidInitialization();
        }
        if ($._initialized != type(uint64).max) {
            $._initialized = type(uint64).max;
            emit Initialized(type(uint64).max);
        }
    }

    /**
     * @dev Returns the highest version that has been initialized. See {reinitializer}.
     */
    function _getInitializedVersion() internal view returns (uint64) {
        return _getInitializableStorage()._initialized;
    }

    /**
     * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
     */
    function _isInitializing() internal view returns (bool) {
        return _getInitializableStorage()._initializing;
    }

    /**
     * @dev Returns a pointer to the storage namespace.
     */
    // solhint-disable-next-line var-name-mixedcase
    function _getInitializableStorage() private pure returns (InitializableStorage storage $) {
        assembly {
            $.slot := INITIALIZABLE_STORAGE
        }
    }
}

// lib/openzeppelin-contracts/contracts/utils/math/Math.sol

// OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    enum Rounding {
        Down, // Toward negative infinity
        Up, // Toward infinity
        Zero // Toward zero
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead
     * of rounding down.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    /**
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
     * with further edits by Uniswap Labs also under MIT license.
     */
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator
    ) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod0 := mul(x, y)
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            require(denominator > prod1);

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
            // See https://cs.stackexchange.com/q/138556/92363.

            // Does not overflow because the denominator cannot be zero at this stage in the function.
            uint256 twos = denominator & (~denominator + 1);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
            // in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 denominator,
        Rounding rounding
    ) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /**
     * @notice Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 2, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 10, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10**64) {
                value /= 10**64;
                result += 64;
            }
            if (value >= 10**32) {
                value /= 10**32;
                result += 32;
            }
            if (value >= 10**16) {
                value /= 10**16;
                result += 16;
            }
            if (value >= 10**8) {
                value /= 10**8;
                result += 8;
            }
            if (value >= 10**4) {
                value /= 10**4;
                result += 4;
            }
            if (value >= 10**2) {
                value /= 10**2;
                result += 2;
            }
            if (value >= 10**1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 256, rounded down, of a positive value.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
        }
    }
}

// lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol

// OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SafeCast.sol)
// This file was procedurally generated from scripts/generate/templates/SafeCast.js.

/**
 * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
 * checks.
 *
 * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
 * easily result in undesired exploitation or bugs, since developers usually
 * assume that overflows raise errors. `SafeCast` restores this intuition by
 * reverting the transaction when such an operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 *
 * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
 * all math on `uint256` and `int256` and then downcasting.
 */
library SafeCast {
    /**
     * @dev Returns the downcasted uint248 from uint256, reverting on
     * overflow (when the input is greater than largest uint248).
     *
     * Counterpart to Solidity's `uint248` operator.
     *
     * Requirements:
     *
     * - input must fit into 248 bits
     *
     * _Available since v4.7._
     */
    function toUint248(uint256 value) internal pure returns (uint248) {
        require(value <= type(uint248).max, "SafeCast: value doesn't fit in 248 bits");
        return uint248(value);
    }

    /**
     * @dev Returns the downcasted uint240 from uint256, reverting on
     * overflow (when the input is greater than largest uint240).
     *
     * Counterpart to Solidity's `uint240` operator.
     *
     * Requirements:
     *
     * - input must fit into 240 bits
     *
     * _Available since v4.7._
     */
    function toUint240(uint256 value) internal pure returns (uint240) {
        require(value <= type(uint240).max, "SafeCast: value doesn't fit in 240 bits");
        return uint240(value);
    }

    /**
     * @dev Returns the downcasted uint232 from uint256, reverting on
     * overflow (when the input is greater than largest uint232).
     *
     * Counterpart to Solidity's `uint232` operator.
     *
     * Requirements:
     *
     * - input must fit into 232 bits
     *
     * _Available since v4.7._
     */
    function toUint232(uint256 value) internal pure returns (uint232) {
        require(value <= type(uint232).max, "SafeCast: value doesn't fit in 232 bits");
        return uint232(value);
    }

    /**
     * @dev Returns the downcasted uint224 from uint256, reverting on
     * overflow (when the input is greater than largest uint224).
     *
     * Counterpart to Solidity's `uint224` operator.
     *
     * Requirements:
     *
     * - input must fit into 224 bits
     *
     * _Available since v4.2._
     */
    function toUint224(uint256 value) internal pure returns (uint224) {
        require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
        return uint224(value);
    }

    /**
     * @dev Returns the downcasted uint216 from uint256, reverting on
     * overflow (when the input is greater than largest uint216).
     *
     * Counterpart to Solidity's `uint216` operator.
     *
     * Requirements:
     *
     * - input must fit into 216 bits
     *
     * _Available since v4.7._
     */
    function toUint216(uint256 value) internal pure returns (uint216) {
        require(value <= type(uint216).max, "SafeCast: value doesn't fit in 216 bits");
        return uint216(value);
    }

    /**
     * @dev Returns the downcasted uint208 from uint256, reverting on
     * overflow (when the input is greater than largest uint208).
     *
     * Counterpart to Solidity's `uint208` operator.
     *
     * Requirements:
     *
     * - input must fit into 208 bits
     *
     * _Available since v4.7._
     */
    function toUint208(uint256 value) internal pure returns (uint208) {
        require(value <= type(uint208).max, "SafeCast: value doesn't fit in 208 bits");
        return uint208(value);
    }

    /**
     * @dev Returns the downcasted uint200 from uint256, reverting on
     * overflow (when the input is greater than largest uint200).
     *
     * Counterpart to Solidity's `uint200` operator.
     *
     * Requirements:
     *
     * - input must fit into 200 bits
     *
     * _Available since v4.7._
     */
    function toUint200(uint256 value) internal pure returns (uint200) {
        require(value <= type(uint200).max, "SafeCast: value doesn't fit in 200 bits");
        return uint200(value);
    }

    /**
     * @dev Returns the downcasted uint192 from uint256, reverting on
     * overflow (when the input is greater than largest uint192).
     *
     * Counterpart to Solidity's `uint192` operator.
     *
     * Requirements:
     *
     * - input must fit into 192 bits
     *
     * _Available since v4.7._
     */
    function toUint192(uint256 value) internal pure returns (uint192) {
        require(value <= type(uint192).max, "SafeCast: value doesn't fit in 192 bits");
        return uint192(value);
    }

    /**
     * @dev Returns the downcasted uint184 from uint256, reverting on
     * overflow (when the input is greater than largest uint184).
     *
     * Counterpart to Solidity's `uint184` operator.
     *
     * Requirements:
     *
     * - input must fit into 184 bits
     *
     * _Available since v4.7._
     */
    function toUint184(uint256 value) internal pure returns (uint184) {
        require(value <= type(uint184).max, "SafeCast: value doesn't fit in 184 bits");
        return uint184(value);
    }

    /**
     * @dev Returns the downcasted uint176 from uint256, reverting on
     * overflow (when the input is greater than largest uint176).
     *
     * Counterpart to Solidity's `uint176` operator.
     *
     * Requirements:
     *
     * - input must fit into 176 bits
     *
     * _Available since v4.7._
     */
    function toUint176(uint256 value) internal pure returns (uint176) {
        require(value <= type(uint176).max, "SafeCast: value doesn't fit in 176 bits");
        return uint176(value);
    }

    /**
     * @dev Returns the downcasted uint168 from uint256, reverting on
     * overflow (when the input is greater than largest uint168).
     *
     * Counterpart to Solidity's `uint168` operator.
     *
     * Requirements:
     *
     * - input must fit into 168 bits
     *
     * _Available since v4.7._
     */
    function toUint168(uint256 value) internal pure returns (uint168) {
        require(value <= type(uint168).max, "SafeCast: value doesn't fit in 168 bits");
        return uint168(value);
    }

    /**
     * @dev Returns the downcasted uint160 from uint256, reverting on
     * overflow (when the input is greater than largest uint160).
     *
     * Counterpart to Solidity's `uint160` operator.
     *
     * Requirements:
     *
     * - input must fit into 160 bits
     *
     * _Available since v4.7._
     */
    function toUint160(uint256 value) internal pure returns (uint160) {
        require(value <= type(uint160).max, "SafeCast: value doesn't fit in 160 bits");
        return uint160(value);
    }

    /**
     * @dev Returns the downcasted uint152 from uint256, reverting on
     * overflow (when the input is greater than largest uint152).
     *
     * Counterpart to Solidity's `uint152` operator.
     *
     * Requirements:
     *
     * - input must fit into 152 bits
     *
     * _Available since v4.7._
     */
    function toUint152(uint256 value) internal pure returns (uint152) {
        require(value <= type(uint152).max, "SafeCast: value doesn't fit in 152 bits");
        return uint152(value);
    }

    /**
     * @dev Returns the downcasted uint144 from uint256, reverting on
     * overflow (when the input is greater than largest uint144).
     *
     * Counterpart to Solidity's `uint144` operator.
     *
     * Requirements:
     *
     * - input must fit into 144 bits
     *
     * _Available since v4.7._
     */
    function toUint144(uint256 value) internal pure returns (uint144) {
        require(value <= type(uint144).max, "SafeCast: value doesn't fit in 144 bits");
        return uint144(value);
    }

    /**
     * @dev Returns the downcasted uint136 from uint256, reverting on
     * overflow (when the input is greater than largest uint136).
     *
     * Counterpart to Solidity's `uint136` operator.
     *
     * Requirements:
     *
     * - input must fit into 136 bits
     *
     * _Available since v4.7._
     */
    function toUint136(uint256 value) internal pure returns (uint136) {
        require(value <= type(uint136).max, "SafeCast: value doesn't fit in 136 bits");
        return uint136(value);
    }

    /**
     * @dev Returns the downcasted uint128 from uint256, reverting on
     * overflow (when the input is greater than largest uint128).
     *
     * Counterpart to Solidity's `uint128` operator.
     *
     * Requirements:
     *
     * - input must fit into 128 bits
     *
     * _Available since v2.5._
     */
    function toUint128(uint256 value) internal pure returns (uint128) {
        require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
        return uint128(value);
    }

    /**
     * @dev Returns the downcasted uint120 from uint256, reverting on
     * overflow (when the input is greater than largest uint120).
     *
     * Counterpart to Solidity's `uint120` operator.
     *
     * Requirements:
     *
     * - input must fit into 120 bits
     *
     * _Available since v4.7._
     */
    function toUint120(uint256 value) internal pure returns (uint120) {
        require(value <= type(uint120).max, "SafeCast: value doesn't fit in 120 bits");
        return uint120(value);
    }

    /**
     * @dev Returns the downcasted uint112 from uint256, reverting on
     * overflow (when the input is greater than largest uint112).
     *
     * Counterpart to Solidity's `uint112` operator.
     *
     * Requirements:
     *
     * - input must fit into 112 bits
     *
     * _Available since v4.7._
     */
    function toUint112(uint256 value) internal pure returns (uint112) {
        require(value <= type(uint112).max, "SafeCast: value doesn't fit in 112 bits");
        return uint112(value);
    }

    /**
     * @dev Returns the downcasted uint104 from uint256, reverting on
     * overflow (when the input is greater than largest uint104).
     *
     * Counterpart to Solidity's `uint104` operator.
     *
     * Requirements:
     *
     * - input must fit into 104 bits
     *
     * _Available since v4.7._
     */
    function toUint104(uint256 value) internal pure returns (uint104) {
        require(value <= type(uint104).max, "SafeCast: value doesn't fit in 104 bits");
        return uint104(value);
    }

    /**
     * @dev Returns the downcasted uint96 from uint256, reverting on
     * overflow (when the input is greater than largest uint96).
     *
     * Counterpart to Solidity's `uint96` operator.
     *
     * Requirements:
     *
     * - input must fit into 96 bits
     *
     * _Available since v4.2._
     */
    function toUint96(uint256 value) internal pure returns (uint96) {
        require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
        return uint96(value);
    }

    /**
     * @dev Returns the downcasted uint88 from uint256, reverting on
     * overflow (when the input is greater than largest uint88).
     *
     * Counterpart to Solidity's `uint88` operator.
     *
     * Requirements:
     *
     * - input must fit into 88 bits
     *
     * _Available since v4.7._
     */
    function toUint88(uint256 value) internal pure returns (uint88) {
        require(value <= type(uint88).max, "SafeCast: value doesn't fit in 88 bits");
        return uint88(value);
    }

    /**
     * @dev Returns the downcasted uint80 from uint256, reverting on
     * overflow (when the input is greater than largest uint80).
     *
     * Counterpart to Solidity's `uint80` operator.
     *
     * Requirements:
     *
     * - input must fit into 80 bits
     *
     * _Available since v4.7._
     */
    function toUint80(uint256 value) internal pure returns (uint80) {
        require(value <= type(uint80).max, "SafeCast: value doesn't fit in 80 bits");
        return uint80(value);
    }

    /**
     * @dev Returns the downcasted uint72 from uint256, reverting on
     * overflow (when the input is greater than largest uint72).
     *
     * Counterpart to Solidity's `uint72` operator.
     *
     * Requirements:
     *
     * - input must fit into 72 bits
     *
     * _Available since v4.7._
     */
    function toUint72(uint256 value) internal pure returns (uint72) {
        require(value <= type(uint72).max, "SafeCast: value doesn't fit in 72 bits");
        return uint72(value);
    }

    /**
     * @dev Returns the downcasted uint64 from uint256, reverting on
     * overflow (when the input is greater than largest uint64).
     *
     * Counterpart to Solidity's `uint64` operator.
     *
     * Requirements:
     *
     * - input must fit into 64 bits
     *
     * _Available since v2.5._
     */
    function toUint64(uint256 value) internal pure returns (uint64) {
        require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
        return uint64(value);
    }

    /**
     * @dev Returns the downcasted uint56 from uint256, reverting on
     * overflow (when the input is greater than largest uint56).
     *
     * Counterpart to Solidity's `uint56` operator.
     *
     * Requirements:
     *
     * - input must fit into 56 bits
     *
     * _Available since v4.7._
     */
    function toUint56(uint256 value) internal pure returns (uint56) {
        require(value <= type(uint56).max, "SafeCast: value doesn't fit in 56 bits");
        return uint56(value);
    }

    /**
     * @dev Returns the downcasted uint48 from uint256, reverting on
     * overflow (when the input is greater than largest uint48).
     *
     * Counterpart to Solidity's `uint48` operator.
     *
     * Requirements:
     *
     * - input must fit into 48 bits
     *
     * _Available since v4.7._
     */
    function toUint48(uint256 value) internal pure returns (uint48) {
        require(value <= type(uint48).max, "SafeCast: value doesn't fit in 48 bits");
        return uint48(value);
    }

    /**
     * @dev Returns the downcasted uint40 from uint256, reverting on
     * overflow (when the input is greater than largest uint40).
     *
     * Counterpart to Solidity's `uint40` operator.
     *
     * Requirements:
     *
     * - input must fit into 40 bits
     *
     * _Available since v4.7._
     */
    function toUint40(uint256 value) internal pure returns (uint40) {
        require(value <= type(uint40).max, "SafeCast: value doesn't fit in 40 bits");
        return uint40(value);
    }

    /**
     * @dev Returns the downcasted uint32 from uint256, reverting on
     * overflow (when the input is greater than largest uint32).
     *
     * Counterpart to Solidity's `uint32` operator.
     *
     * Requirements:
     *
     * - input must fit into 32 bits
     *
     * _Available since v2.5._
     */
    function toUint32(uint256 value) internal pure returns (uint32) {
        require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
        return uint32(value);
    }

    /**
     * @dev Returns the downcasted uint24 from uint256, reverting on
     * overflow (when the input is greater than largest uint24).
     *
     * Counterpart to Solidity's `uint24` operator.
     *
     * Requirements:
     *
     * - input must fit into 24 bits
     *
     * _Available since v4.7._
     */
    function toUint24(uint256 value) internal pure returns (uint24) {
        require(value <= type(uint24).max, "SafeCast: value doesn't fit in 24 bits");
        return uint24(value);
    }

    /**
     * @dev Returns the downcasted uint16 from uint256, reverting on
     * overflow (when the input is greater than largest uint16).
     *
     * Counterpart to Solidity's `uint16` operator.
     *
     * Requirements:
     *
     * - input must fit into 16 bits
     *
     * _Available since v2.5._
     */
    function toUint16(uint256 value) internal pure returns (uint16) {
        require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
        return uint16(value);
    }

    /**
     * @dev Returns the downcasted uint8 from uint256, reverting on
     * overflow (when the input is greater than largest uint8).
     *
     * Counterpart to Solidity's `uint8` operator.
     *
     * Requirements:
     *
     * - input must fit into 8 bits
     *
     * _Available since v2.5._
     */
    function toUint8(uint256 value) internal pure returns (uint8) {
        require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
        return uint8(value);
    }

    /**
     * @dev Converts a signed int256 into an unsigned uint256.
     *
     * Requirements:
     *
     * - input must be greater than or equal to 0.
     *
     * _Available since v3.0._
     */
    function toUint256(int256 value) internal pure returns (uint256) {
        require(value >= 0, "SafeCast: value must be positive");
        return uint256(value);
    }

    /**
     * @dev Returns the downcasted int248 from int256, reverting on
     * overflow (when the input is less than smallest int248 or
     * greater than largest int248).
     *
     * Counterpart to Solidity's `int248` operator.
     *
     * Requirements:
     *
     * - input must fit into 248 bits
     *
     * _Available since v4.7._
     */
    function toInt248(int256 value) internal pure returns (int248 downcasted) {
        downcasted = int248(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 248 bits");
    }

    /**
     * @dev Returns the downcasted int240 from int256, reverting on
     * overflow (when the input is less than smallest int240 or
     * greater than largest int240).
     *
     * Counterpart to Solidity's `int240` operator.
     *
     * Requirements:
     *
     * - input must fit into 240 bits
     *
     * _Available since v4.7._
     */
    function toInt240(int256 value) internal pure returns (int240 downcasted) {
        downcasted = int240(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 240 bits");
    }

    /**
     * @dev Returns the downcasted int232 from int256, reverting on
     * overflow (when the input is less than smallest int232 or
     * greater than largest int232).
     *
     * Counterpart to Solidity's `int232` operator.
     *
     * Requirements:
     *
     * - input must fit into 232 bits
     *
     * _Available since v4.7._
     */
    function toInt232(int256 value) internal pure returns (int232 downcasted) {
        downcasted = int232(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 232 bits");
    }

    /**
     * @dev Returns the downcasted int224 from int256, reverting on
     * overflow (when the input is less than smallest int224 or
     * greater than largest int224).
     *
     * Counterpart to Solidity's `int224` operator.
     *
     * Requirements:
     *
     * - input must fit into 224 bits
     *
     * _Available since v4.7._
     */
    function toInt224(int256 value) internal pure returns (int224 downcasted) {
        downcasted = int224(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 224 bits");
    }

    /**
     * @dev Returns the downcasted int216 from int256, reverting on
     * overflow (when the input is less than smallest int216 or
     * greater than largest int216).
     *
     * Counterpart to Solidity's `int216` operator.
     *
     * Requirements:
     *
     * - input must fit into 216 bits
     *
     * _Available since v4.7._
     */
    function toInt216(int256 value) internal pure returns (int216 downcasted) {
        downcasted = int216(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 216 bits");
    }

    /**
     * @dev Returns the downcasted int208 from int256, reverting on
     * overflow (when the input is less than smallest int208 or
     * greater than largest int208).
     *
     * Counterpart to Solidity's `int208` operator.
     *
     * Requirements:
     *
     * - input must fit into 208 bits
     *
     * _Available since v4.7._
     */
    function toInt208(int256 value) internal pure returns (int208 downcasted) {
        downcasted = int208(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 208 bits");
    }

    /**
     * @dev Returns the downcasted int200 from int256, reverting on
     * overflow (when the input is less than smallest int200 or
     * greater than largest int200).
     *
     * Counterpart to Solidity's `int200` operator.
     *
     * Requirements:
     *
     * - input must fit into 200 bits
     *
     * _Available since v4.7._
     */
    function toInt200(int256 value) internal pure returns (int200 downcasted) {
        downcasted = int200(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 200 bits");
    }

    /**
     * @dev Returns the downcasted int192 from int256, reverting on
     * overflow (when the input is less than smallest int192 or
     * greater than largest int192).
     *
     * Counterpart to Solidity's `int192` operator.
     *
     * Requirements:
     *
     * - input must fit into 192 bits
     *
     * _Available since v4.7._
     */
    function toInt192(int256 value) internal pure returns (int192 downcasted) {
        downcasted = int192(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 192 bits");
    }

    /**
     * @dev Returns the downcasted int184 from int256, reverting on
     * overflow (when the input is less than smallest int184 or
     * greater than largest int184).
     *
     * Counterpart to Solidity's `int184` operator.
     *
     * Requirements:
     *
     * - input must fit into 184 bits
     *
     * _Available since v4.7._
     */
    function toInt184(int256 value) internal pure returns (int184 downcasted) {
        downcasted = int184(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 184 bits");
    }

    /**
     * @dev Returns the downcasted int176 from int256, reverting on
     * overflow (when the input is less than smallest int176 or
     * greater than largest int176).
     *
     * Counterpart to Solidity's `int176` operator.
     *
     * Requirements:
     *
     * - input must fit into 176 bits
     *
     * _Available since v4.7._
     */
    function toInt176(int256 value) internal pure returns (int176 downcasted) {
        downcasted = int176(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 176 bits");
    }

    /**
     * @dev Returns the downcasted int168 from int256, reverting on
     * overflow (when the input is less than smallest int168 or
     * greater than largest int168).
     *
     * Counterpart to Solidity's `int168` operator.
     *
     * Requirements:
     *
     * - input must fit into 168 bits
     *
     * _Available since v4.7._
     */
    function toInt168(int256 value) internal pure returns (int168 downcasted) {
        downcasted = int168(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 168 bits");
    }

    /**
     * @dev Returns the downcasted int160 from int256, reverting on
     * overflow (when the input is less than smallest int160 or
     * greater than largest int160).
     *
     * Counterpart to Solidity's `int160` operator.
     *
     * Requirements:
     *
     * - input must fit into 160 bits
     *
     * _Available since v4.7._
     */
    function toInt160(int256 value) internal pure returns (int160 downcasted) {
        downcasted = int160(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 160 bits");
    }

    /**
     * @dev Returns the downcasted int152 from int256, reverting on
     * overflow (when the input is less than smallest int152 or
     * greater than largest int152).
     *
     * Counterpart to Solidity's `int152` operator.
     *
     * Requirements:
     *
     * - input must fit into 152 bits
     *
     * _Available since v4.7._
     */
    function toInt152(int256 value) internal pure returns (int152 downcasted) {
        downcasted = int152(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 152 bits");
    }

    /**
     * @dev Returns the downcasted int144 from int256, reverting on
     * overflow (when the input is less than smallest int144 or
     * greater than largest int144).
     *
     * Counterpart to Solidity's `int144` operator.
     *
     * Requirements:
     *
     * - input must fit into 144 bits
     *
     * _Available since v4.7._
     */
    function toInt144(int256 value) internal pure returns (int144 downcasted) {
        downcasted = int144(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 144 bits");
    }

    /**
     * @dev Returns the downcasted int136 from int256, reverting on
     * overflow (when the input is less than smallest int136 or
     * greater than largest int136).
     *
     * Counterpart to Solidity's `int136` operator.
     *
     * Requirements:
     *
     * - input must fit into 136 bits
     *
     * _Available since v4.7._
     */
    function toInt136(int256 value) internal pure returns (int136 downcasted) {
        downcasted = int136(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 136 bits");
    }

    /**
     * @dev Returns the downcasted int128 from int256, reverting on
     * overflow (when the input is less than smallest int128 or
     * greater than largest int128).
     *
     * Counterpart to Solidity's `int128` operator.
     *
     * Requirements:
     *
     * - input must fit into 128 bits
     *
     * _Available since v3.1._
     */
    function toInt128(int256 value) internal pure returns (int128 downcasted) {
        downcasted = int128(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 128 bits");
    }

    /**
     * @dev Returns the downcasted int120 from int256, reverting on
     * overflow (when the input is less than smallest int120 or
     * greater than largest int120).
     *
     * Counterpart to Solidity's `int120` operator.
     *
     * Requirements:
     *
     * - input must fit into 120 bits
     *
     * _Available since v4.7._
     */
    function toInt120(int256 value) internal pure returns (int120 downcasted) {
        downcasted = int120(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 120 bits");
    }

    /**
     * @dev Returns the downcasted int112 from int256, reverting on
     * overflow (when the input is less than smallest int112 or
     * greater than largest int112).
     *
     * Counterpart to Solidity's `int112` operator.
     *
     * Requirements:
     *
     * - input must fit into 112 bits
     *
     * _Available since v4.7._
     */
    function toInt112(int256 value) internal pure returns (int112 downcasted) {
        downcasted = int112(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 112 bits");
    }

    /**
     * @dev Returns the downcasted int104 from int256, reverting on
     * overflow (when the input is less than smallest int104 or
     * greater than largest int104).
     *
     * Counterpart to Solidity's `int104` operator.
     *
     * Requirements:
     *
     * - input must fit into 104 bits
     *
     * _Available since v4.7._
     */
    function toInt104(int256 value) internal pure returns (int104 downcasted) {
        downcasted = int104(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 104 bits");
    }

    /**
     * @dev Returns the downcasted int96 from int256, reverting on
     * overflow (when the input is less than smallest int96 or
     * greater than largest int96).
     *
     * Counterpart to Solidity's `int96` operator.
     *
     * Requirements:
     *
     * - input must fit into 96 bits
     *
     * _Available since v4.7._
     */
    function toInt96(int256 value) internal pure returns (int96 downcasted) {
        downcasted = int96(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 96 bits");
    }

    /**
     * @dev Returns the downcasted int88 from int256, reverting on
     * overflow (when the input is less than smallest int88 or
     * greater than largest int88).
     *
     * Counterpart to Solidity's `int88` operator.
     *
     * Requirements:
     *
     * - input must fit into 88 bits
     *
     * _Available since v4.7._
     */
    function toInt88(int256 value) internal pure returns (int88 downcasted) {
        downcasted = int88(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 88 bits");
    }

    /**
     * @dev Returns the downcasted int80 from int256, reverting on
     * overflow (when the input is less than smallest int80 or
     * greater than largest int80).
     *
     * Counterpart to Solidity's `int80` operator.
     *
     * Requirements:
     *
     * - input must fit into 80 bits
     *
     * _Available since v4.7._
     */
    function toInt80(int256 value) internal pure returns (int80 downcasted) {
        downcasted = int80(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 80 bits");
    }

    /**
     * @dev Returns the downcasted int72 from int256, reverting on
     * overflow (when the input is less than smallest int72 or
     * greater than largest int72).
     *
     * Counterpart to Solidity's `int72` operator.
     *
     * Requirements:
     *
     * - input must fit into 72 bits
     *
     * _Available since v4.7._
     */
    function toInt72(int256 value) internal pure returns (int72 downcasted) {
        downcasted = int72(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 72 bits");
    }

    /**
     * @dev Returns the downcasted int64 from int256, reverting on
     * overflow (when the input is less than smallest int64 or
     * greater than largest int64).
     *
     * Counterpart to Solidity's `int64` operator.
     *
     * Requirements:
     *
     * - input must fit into 64 bits
     *
     * _Available since v3.1._
     */
    function toInt64(int256 value) internal pure returns (int64 downcasted) {
        downcasted = int64(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 64 bits");
    }

    /**
     * @dev Returns the downcasted int56 from int256, reverting on
     * overflow (when the input is less than smallest int56 or
     * greater than largest int56).
     *
     * Counterpart to Solidity's `int56` operator.
     *
     * Requirements:
     *
     * - input must fit into 56 bits
     *
     * _Available since v4.7._
     */
    function toInt56(int256 value) internal pure returns (int56 downcasted) {
        downcasted = int56(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 56 bits");
    }

    /**
     * @dev Returns the downcasted int48 from int256, reverting on
     * overflow (when the input is less than smallest int48 or
     * greater than largest int48).
     *
     * Counterpart to Solidity's `int48` operator.
     *
     * Requirements:
     *
     * - input must fit into 48 bits
     *
     * _Available since v4.7._
     */
    function toInt48(int256 value) internal pure returns (int48 downcasted) {
        downcasted = int48(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 48 bits");
    }

    /**
     * @dev Returns the downcasted int40 from int256, reverting on
     * overflow (when the input is less than smallest int40 or
     * greater than largest int40).
     *
     * Counterpart to Solidity's `int40` operator.
     *
     * Requirements:
     *
     * - input must fit into 40 bits
     *
     * _Available since v4.7._
     */
    function toInt40(int256 value) internal pure returns (int40 downcasted) {
        downcasted = int40(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 40 bits");
    }

    /**
     * @dev Returns the downcasted int32 from int256, reverting on
     * overflow (when the input is less than smallest int32 or
     * greater than largest int32).
     *
     * Counterpart to Solidity's `int32` operator.
     *
     * Requirements:
     *
     * - input must fit into 32 bits
     *
     * _Available since v3.1._
     */
    function toInt32(int256 value) internal pure returns (int32 downcasted) {
        downcasted = int32(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 32 bits");
    }

    /**
     * @dev Returns the downcasted int24 from int256, reverting on
     * overflow (when the input is less than smallest int24 or
     * greater than largest int24).
     *
     * Counterpart to Solidity's `int24` operator.
     *
     * Requirements:
     *
     * - input must fit into 24 bits
     *
     * _Available since v4.7._
     */
    function toInt24(int256 value) internal pure returns (int24 downcasted) {
        downcasted = int24(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 24 bits");
    }

    /**
     * @dev Returns the downcasted int16 from int256, reverting on
     * overflow (when the input is less than smallest int16 or
     * greater than largest int16).
     *
     * Counterpart to Solidity's `int16` operator.
     *
     * Requirements:
     *
     * - input must fit into 16 bits
     *
     * _Available since v3.1._
     */
    function toInt16(int256 value) internal pure returns (int16 downcasted) {
        downcasted = int16(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 16 bits");
    }

    /**
     * @dev Returns the downcasted int8 from int256, reverting on
     * overflow (when the input is less than smallest int8 or
     * greater than largest int8).
     *
     * Counterpart to Solidity's `int8` operator.
     *
     * Requirements:
     *
     * - input must fit into 8 bits
     *
     * _Available since v3.1._
     */
    function toInt8(int256 value) internal pure returns (int8 downcasted) {
        downcasted = int8(value);
        require(downcasted == value, "SafeCast: value doesn't fit in 8 bits");
    }

    /**
     * @dev Converts an unsigned uint256 into a signed int256.
     *
     * Requirements:
     *
     * - input must be less than or equal to maxInt256.
     *
     * _Available since v3.0._
     */
    function toInt256(uint256 value) internal pure returns (int256) {
        // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
        require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
        return int256(value);
    }
}

// lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol

// OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)

/**
 * @dev Library for reading and writing primitive types to specific storage slots.
 *
 * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
 * This library helps with reading and writing to such slots without the need for inline assembly.
 *
 * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
 *
 * Example usage to set ERC1967 implementation slot:
 * ```
 * contract ERC1967 {
 *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
 *
 *     function _getImplementation() internal view returns (address) {
 *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
 *     }
 *
 *     function _setImplementation(address newImplementation) internal {
 *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
 *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
 *     }
 * }
 * ```
 *
 * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
 */
library StorageSlot {
    struct AddressSlot {
        address value;
    }

    struct BooleanSlot {
        bool value;
    }

    struct Bytes32Slot {
        bytes32 value;
    }

    struct Uint256Slot {
        uint256 value;
    }

    /**
     * @dev Returns an `AddressSlot` with member `value` located at `slot`.
     */
    function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
     */
    function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
     */
    function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
     */
    function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }
}

// lib/openzeppelin-contracts/contracts/interfaces/draft-IERC1822.sol

// OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)

/**
 * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
 * proxy whose upgrades are fully controlled by the current implementation.
 */
interface IERC1822Proxiable {
    /**
     * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
     * address.
     *
     * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
     * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
     * function revert if invoked through a proxy.
     */
    function proxiableUUID() external view returns (bytes32);
}

// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/draft-IERC20Permit.sol

// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)

/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

// lib/openzeppelin-contracts/contracts/interfaces/draft-IERC6093.sol

// OpenZeppelin Contracts (last updated v5.0.0) (interfaces/draft-IERC6093.sol)

/**
 * @dev Standard ERC-20 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC-20 tokens.
 */
interface IERC20Errors {
    /**
     * @dev Indicates an error related to the current `balance` of a `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param balance Current balance for the interacting account.
     * @param needed Minimum amount required to perform a transfer.
     */
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC20InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC20InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `spender`’s `allowance`. Used in transfers.
     * @param spender Address that may be allowed to operate on tokens without being their owner.
     * @param allowance Amount of tokens a `spender` is allowed to operate with.
     * @param needed Minimum amount required to perform a transfer.
     */
    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);

    /**
     * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
    error ERC20InvalidApprover(address approver);

    /**
     * @dev Indicates a failure with the `spender` to be approved. Used in approvals.
     * @param spender Address that may be allowed to operate on tokens without being their owner.
     */
    error ERC20InvalidSpender(address spender);
}

/**
 * @dev Standard ERC-721 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC-721 tokens.
 */
interface IERC721Errors {
    /**
     * @dev Indicates that an address can't be an owner. For example, `address(0)` is a forbidden owner in ERC-20.
     * Used in balance queries.
     * @param owner Address of the current owner of a token.
     */
    error ERC721InvalidOwner(address owner);

    /**
     * @dev Indicates a `tokenId` whose `owner` is the zero address.
     * @param tokenId Identifier number of a token.
     */
    error ERC721NonexistentToken(uint256 tokenId);

    /**
     * @dev Indicates an error related to the ownership over a particular token. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param tokenId Identifier number of a token.
     * @param owner Address of the current owner of a token.
     */
    error ERC721IncorrectOwner(address sender, uint256 tokenId, address owner);

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC721InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC721InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `operator`’s approval. Used in transfers.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     * @param tokenId Identifier number of a token.
     */
    error ERC721InsufficientApproval(address operator, uint256 tokenId);

    /**
     * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
    error ERC721InvalidApprover(address approver);

    /**
     * @dev Indicates a failure with the `operator` to be approved. Used in approvals.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     */
    error ERC721InvalidOperator(address operator);
}

/**
 * @dev Standard ERC-1155 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC-1155 tokens.
 */
interface IERC1155Errors {
    /**
     * @dev Indicates an error related to the current `balance` of a `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param balance Current balance for the interacting account.
     * @param needed Minimum amount required to perform a transfer.
     * @param tokenId Identifier number of a token.
     */
    error ERC1155InsufficientBalance(address sender, uint256 balance, uint256 needed, uint256 tokenId);

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC1155InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC1155InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `operator`’s approval. Used in transfers.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     * @param owner Address of the current owner of a token.
     */
    error ERC1155MissingApprovalForAll(address operator, address owner);

    /**
     * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
    error ERC1155InvalidApprover(address approver);

    /**
     * @dev Indicates a failure with the `operator` to be approved. Used in approvals.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     */
    error ERC1155InvalidOperator(address operator);

    /**
     * @dev Indicates an array length mismatch between ids and values in a safeBatchTransferFrom operation.
     * Used in batch transfers.
     * @param idsLength Length of the array of token identifiers
     * @param valuesLength Length of the array of token amounts
     */
    error ERC1155InvalidArrayLength(uint256 idsLength, uint256 valuesLength);
}

// lib/openzeppelin-contracts-upgradeable/contracts/utils/ContextUpgradeable.sol

// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal onlyInitializing {
    }

    function __Context_init_unchained() internal onlyInitializing {
    }
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// src/libraries/FeeLib.sol

library FeeLib {
    using Math for uint;

    uint private constant BP = 1e4;

    /// @dev Calculates the fees that should be added to an amount `shares` that does already include fees.
    /// Used in {IERC4626-deposit}, {IERC4626-mint}, {IERC4626-withdraw} and {IERC4626-previewRedeem} operations.
    function feeOnRaw(
        uint shares,
        uint feeBP
    ) internal pure returns (uint) {
        return shares.mulDiv(feeBP, BP, Math.Rounding.Up);
    }

    /// @dev Calculates the fee part of an amount `shares` that deoes not includes fees.
    /// Used in {IERC4626-previewDeposit} and {IERC4626-previewRedeem} operations.
    function feeOnTotal(
        uint shares,
        uint feeBP
    ) internal pure returns (uint) {
        return shares.mulDiv(feeBP, feeBP + BP, Math.Rounding.Up);
    }
}

// src/interfaces/core/IBeraborrowCore.sol

interface IBeraborrowCore {

    // --- Public variables ---
    function metaBeraborrowCore() external view returns (IMetaBeraborrowCore);
    function startTime() external view returns (uint256);
    function CCR() external view returns (uint256);
    function dmBootstrapPeriod() external view returns (uint64);
    function isPeriphery(address peripheryContract) external view returns (bool);

    // --- External functions ---

    function setPeripheryEnabled(address _periphery, bool _enabled) external;
    function setDMBootstrapPeriod(address dm, uint64 _bootstrapPeriod) external;
    function setNewCCR(uint256 _CCR) external;

    function priceFeed() external view returns (address);
    function owner() external view returns (address);
    function pendingOwner() external view returns (address);
    function guardian() external view returns (address);
    function manager() external view returns (address);
    function feeReceiver() external view returns (address);
    function paused() external view returns (bool);
    function lspBootstrapPeriod() external view returns (uint64);
    function getLspEntryFee(address rebalancer) external view returns (uint16);
    function getLspExitFee(address rebalancer) external view returns (uint16);
    function getPeripheryFlashLoanFee(address peripheryContract) external view returns (uint16);

    // --- Events ---
    event CCRSet(uint256 initialCCR);
    event DMBootstrapPeriodSet(address dm, uint64 bootstrapPeriod);
    event PeripheryEnabled(address indexed periphery, bool enabled);
}

// lib/openzeppelin-contracts/contracts/interfaces/IERC20.sol

// OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)

// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol

// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// src/libraries/PriceLib.sol

library PriceLib {
    using Math for uint;

    // WAD adjusted result
    function convertToValue(uint amount, uint price, uint8 decimals) internal pure returns (uint) {
        return amount * price / 10 ** decimals;
    }

    // Coll decimal adjust amount result
    function convertAssetsToCollAmount(uint assets, uint collPrice, uint nectPrice, uint8 vaultDecimals, uint8 collDecimals, Math.Rounding rounding) internal pure returns (uint) {
        uint assetsUsdValue = assets.mulDiv(nectPrice, 10 ** vaultDecimals, rounding);

        if (collPrice != 0) {
            return assetsUsdValue.mulDiv(10 ** collDecimals, collPrice, rounding);
        } else {
            return 0;
        }
    }

    function convertCollAmountToAssets(uint collAmount, uint collPrice, uint nectPrice, uint8 vaultDecimals, uint8 collDecimals) internal pure returns (uint) {
        uint collUsdValue = collAmount * collPrice / 10 ** collDecimals;
        
        if (nectPrice != 0) {
            return collUsdValue * 10 ** vaultDecimals / nectPrice;
        } else {
            return 0;
        }
    }
}

// src/interfaces/utils/tokens/IAsset.sol

interface IAsset is IERC20 {
    function decimals() external view returns (uint8);
}

// lib/openzeppelin-contracts/contracts/interfaces/IERC4626.sol

// OpenZeppelin Contracts (last updated v4.8.0) (interfaces/IERC4626.sol)

/**
 * @dev Interface of the ERC4626 "Tokenized Vault Standard", as defined in
 * https://eips.ethereum.org/EIPS/eip-4626[ERC-4626].
 *
 * _Available since v4.7._
 */
interface IERC4626 is IERC20, IERC20Metadata {
    event Deposit(address indexed sender, address indexed owner, uint256 assets, uint256 shares);

    event Withdraw(
        address indexed sender,
        address indexed receiver,
        address indexed owner,
        uint256 assets,
        uint256 shares
    );

    /**
     * @dev Returns the address of the underlying token used for the Vault for accounting, depositing, and withdrawing.
     *
     * - MUST be an ERC-20 token contract.
     * - MUST NOT revert.
     */
    function asset() external view returns (address assetTokenAddress);

    /**
     * @dev Returns the total amount of the underlying asset that is “managed” by Vault.
     *
     * - SHOULD include any compounding that occurs from yield.
     * - MUST be inclusive of any fees that are charged against assets in the Vault.
     * - MUST NOT revert.
     */
    function totalAssets() external view returns (uint256 totalManagedAssets);

    /**
     * @dev Returns the amount of shares that the Vault would exchange for the amount of assets provided, in an ideal
     * scenario where all the conditions are met.
     *
     * - MUST NOT be inclusive of any fees that are charged against assets in the Vault.
     * - MUST NOT show any variations depending on the caller.
     * - MUST NOT reflect slippage or other on-chain conditions, when performing the actual exchange.
     * - MUST NOT revert.
     *
     * NOTE: This calculation MAY NOT reflect the “per-user” price-per-share, and instead should reflect the
     * “average-user’s” price-per-share, meaning what the average user should expect to see when exchanging to and
     * from.
     */
    function convertToShares(uint256 assets) external view returns (uint256 shares);

    /**
     * @dev Returns the amount of assets that the Vault would exchange for the amount of shares provided, in an ideal
     * scenario where all the conditions are met.
     *
     * - MUST NOT be inclusive of any fees that are charged against assets in the Vault.
     * - MUST NOT show any variations depending on the caller.
     * - MUST NOT reflect slippage or other on-chain conditions, when performing the actual exchange.
     * - MUST NOT revert.
     *
     * NOTE: This calculation MAY NOT reflect the “per-user” price-per-share, and instead should reflect the
     * “average-user’s” price-per-share, meaning what the average user should expect to see when exchanging to and
     * from.
     */
    function convertToAssets(uint256 shares) external view returns (uint256 assets);

    /**
     * @dev Returns the maximum amount of the underlying asset that can be deposited into the Vault for the receiver,
     * through a deposit call.
     *
     * - MUST return a limited value if receiver is subject to some deposit limit.
     * - MUST return 2 ** 256 - 1 if there is no limit on the maximum amount of assets that may be deposited.
     * - MUST NOT revert.
     */
    function maxDeposit(address receiver) external view returns (uint256 maxAssets);

    /**
     * @dev Allows an on-chain or off-chain user to simulate the effects of their deposit at the current block, given
     * current on-chain conditions.
     *
     * - MUST return as close to and no more than the exact amount of Vault shares that would be minted in a deposit
     *   call in the same transaction. I.e. deposit should return the same or more shares as previewDeposit if called
     *   in the same transaction.
     * - MUST NOT account for deposit limits like those returned from maxDeposit and should always act as though the
     *   deposit would be accepted, regardless if the user has enough tokens approved, etc.
     * - MUST be inclusive of deposit fees. Integrators should be aware of the existence of deposit fees.
     * - MUST NOT revert.
     *
     * NOTE: any unfavorable discrepancy between convertToShares and previewDeposit SHOULD be considered slippage in
     * share price or some other type of condition, meaning the depositor will lose assets by depositing.
     */
    function previewDeposit(uint256 assets) external view returns (uint256 shares);

    /**
     * @dev Mints shares Vault shares to receiver by depositing exactly amount of underlying tokens.
     *
     * - MUST emit the Deposit event.
     * - MAY support an additional flow in which the underlying tokens are owned by the Vault contract before the
     *   deposit execution, and are accounted for during deposit.
     * - MUST revert if all of assets cannot be deposited (due to deposit limit being reached, slippage, the user not
     *   approving enough underlying tokens to the Vault contract, etc).
     *
     * NOTE: most implementations will require pre-approval of the Vault with the Vault’s underlying asset token.
     */
    function deposit(uint256 assets, address receiver) external returns (uint256 shares);

    /**
     * @dev Returns the maximum amount of the Vault shares that can be minted for the receiver, through a mint call.
     * - MUST return a limited value if receiver is subject to some mint limit.
     * - MUST return 2 ** 256 - 1 if there is no limit on the maximum amount of shares that may be minted.
     * - MUST NOT revert.
     */
    function maxMint(address receiver) external view returns (uint256 maxShares);

    /**
     * @dev Allows an on-chain or off-chain user to simulate the effects of their mint at the current block, given
     * current on-chain conditions.
     *
     * - MUST return as close to and no fewer than the exact amount of assets that would be deposited in a mint call
     *   in the same transaction. I.e. mint should return the same or fewer assets as previewMint if called in the
     *   same transaction.
     * - MUST NOT account for mint limits like those returned from maxMint and should always act as though the mint
     *   would be accepted, regardless if the user has enough tokens approved, etc.
     * - MUST be inclusive of deposit fees. Integrators should be aware of the existence of deposit fees.
     * - MUST NOT revert.
     *
     * NOTE: any unfavorable discrepancy between convertToAssets and previewMint SHOULD be considered slippage in
     * share price or some other type of condition, meaning the depositor will lose assets by minting.
     */
    function previewMint(uint256 shares) external view returns (uint256 assets);

    /**
     * @dev Mints exactly shares Vault shares to receiver by depositing amount of underlying tokens.
     *
     * - MUST emit the Deposit event.
     * - MAY support an additional flow in which the underlying tokens are owned by the Vault contract before the mint
     *   execution, and are accounted for during mint.
     * - MUST revert if all of shares cannot be minted (due to deposit limit being reached, slippage, the user not
     *   approving enough underlying tokens to the Vault contract, etc).
     *
     * NOTE: most implementations will require pre-approval of the Vault with the Vault’s underlying asset token.
     */
    function mint(uint256 shares, address receiver) external returns (uint256 assets);

    /**
     * @dev Returns the maximum amount of the underlying asset that can be withdrawn from the owner balance in the
     * Vault, through a withdraw call.
     *
     * - MUST return a limited value if owner is subject to some withdrawal limit or timelock.
     * - MUST NOT revert.
     */
    function maxWithdraw(address owner) external view returns (uint256 maxAssets);

    /**
     * @dev Allows an on-chain or off-chain user to simulate the effects of their withdrawal at the current block,
     * given current on-chain conditions.
     *
     * - MUST return as close to and no fewer than the exact amount of Vault shares that would be burned in a withdraw
     *   call in the same transaction. I.e. withdraw should return the same or fewer shares as previewWithdraw if
     *   called
     *   in the same transaction.
     * - MUST NOT account for withdrawal limits like those returned from maxWithdraw and should always act as though
     *   the withdrawal would be accepted, regardless if the user has enough shares, etc.
     * - MUST be inclusive of withdrawal fees. Integrators should be aware of the existence of withdrawal fees.
     * - MUST NOT revert.
     *
     * NOTE: any unfavorable discrepancy between convertToShares and previewWithdraw SHOULD be considered slippage in
     * share price or some other type of condition, meaning the depositor will lose assets by depositing.
     */
    function previewWithdraw(uint256 assets) external view returns (uint256 shares);

    /**
     * @dev Burns shares from owner and sends exactly assets of underlying tokens to receiver.
     *
     * - MUST emit the Withdraw event.
     * - MAY support an additional flow in which the underlying tokens are owned by the Vault contract before the
     *   withdraw execution, and are accounted for during withdraw.
     * - MUST revert if all of assets cannot be withdrawn (due to withdrawal limit being reached, slippage, the owner
     *   not having enough shares, etc).
     *
     * Note that some implementations will require pre-requesting to the Vault before a withdrawal may be performed.
     * Those methods should be performed separately.
     */
    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) external returns (uint256 shares);

    /**
     * @dev Returns the maximum amount of Vault shares that can be redeemed from the owner balance in the Vault,
     * through a redeem call.
     *
     * - MUST return a limited value if owner is subject to some withdrawal limit or timelock.
     * - MUST return balanceOf(owner) if owner is not subject to any withdrawal limit or timelock.
     * - MUST NOT revert.
     */
    function maxRedeem(address owner) external view returns (uint256 maxShares);

    /**
     * @dev Allows an on-chain or off-chain user to simulate the effects of their redeemption at the current block,
     * given current on-chain conditions.
     *
     * - MUST return as close to and no more than the exact amount of assets that would be withdrawn in a redeem call
     *   in the same transaction. I.e. redeem should return the same or more assets as previewRedeem if called in the
     *   same transaction.
     * - MUST NOT account for redemption limits like those returned from maxRedeem and should always act as though the
     *   redemption would be accepted, regardless if the user has enough shares, etc.
     * - MUST be inclusive of withdrawal fees. Integrators should be aware of the existence of withdrawal fees.
     * - MUST NOT revert.
     *
     * NOTE: any unfavorable discrepancy between convertToAssets and previewRedeem SHOULD be considered slippage in
     * share price or some other type of condition, meaning the depositor will lose assets by redeeming.
     */
    function previewRedeem(uint256 shares) external view returns (uint256 assets);

    /**
     * @dev Burns exactly shares from owner and sends assets of underlying tokens to receiver.
     *
     * - MUST emit the Withdraw event.
     * - MAY support an additional flow in which the underlying tokens are owned by the Vault contract before the
     *   redeem execution, and are accounted for during redeem.
     * - MUST revert if all of shares cannot be redeemed (due to withdrawal limit being reached, slippage, the owner
     *   not having enough shares, etc).
     *
     * NOTE: some implementations will require pre-requesting to the Vault before a withdrawal may be performed.
     * Those methods should be performed separately.
     */
    function redeem(
        uint256 shares,
        address receiver,
        address owner
    ) external returns (uint256 assets);
}

// src/interfaces/core/vaults/IInfraredWrapper.sol

interface IInfraredWrapper is IERC20 {
    function metaBeraborrowCore() external view returns (address);
    function infraredCollVault() external view returns (address);
    function decimals() external view returns (uint8);
    function depositFor(address account, uint256 amount) external returns (bool);
    function withdrawTo(address account, uint256 amount) external returns (bool);
    function recover(address account) external returns (uint256);
}

// src/interfaces/core/IDenManager.sol

interface IDenManager {
    event BaseRateUpdated(uint256 _baseRate);
    event CollateralSent(address _to, uint256 _amount);
    event LTermsUpdated(uint256 _L_collateral, uint256 _L_debt);
    event LastFeeOpTimeUpdated(uint256 _lastFeeOpTime);
    event Redemption(
        address indexed _redeemer,
        uint256 _attemptedDebtAmount,
        uint256 _actualDebtAmount,
        uint256 _collateralSent,
        uint256 _collateralFee
    );
    event SystemSnapshotsUpdated(uint256 _totalStakesSnapshot, uint256 _totalCollateralSnapshot);
    event TotalStakesUpdated(uint256 _newTotalStakes);
    event DenIndexUpdated(address _borrower, uint256 _newIndex);
    event DenSnapshotsUpdated(uint256 _L_collateral, uint256 _L_debt);
    event DenUpdated(address indexed _borrower, uint256 _debt, uint256 _coll, uint256 _stake, uint8 _operation);

    function addCollateralSurplus(address borrower, uint256 collSurplus) external;

    function applyPendingRewards(address _borrower) external returns (uint256 coll, uint256 debt);

    function claimCollateral(address borrower, address _receiver) external;

    function closeDen(address _borrower, address _receiver, uint256 collAmount, uint256 debtAmount) external;

    function closeDenByLiquidation(address _borrower) external;

    function setCollVaultRouter(address _collVaultRouter) external;

    function collectInterests() external;

    function decayBaseRateAndGetBorrowingFee(uint256 _debt) external returns (uint256);

    function decreaseDebtAndSendCollateral(address account, uint256 debt, uint256 coll) external;

    function fetchPrice() external view returns (uint256);

    function finalizeLiquidation(
        address _liquidator,
        uint256 _debt,
        uint256 _coll,
        uint256 _collSurplus,
        uint256 _debtGasComp,
        uint256 _collGasComp
    ) external;

    function getEntireSystemBalances() external view returns (uint256, uint256, uint256);

    function movePendingDenRewardsToActiveBalances(uint256 _debt, uint256 _collateral) external;

    function openDen(
        address _borrower,
        uint256 _collateralAmount,
        uint256 _compositeDebt,
        uint256 NICR,
        address _upperHint,
        address _lowerHint
    ) external returns (uint256 stake, uint256 arrayIndex);

    function redeemCollateral(
        uint256 _debtAmount,
        address _firstRedemptionHint,
        address _upperPartialRedemptionHint,
        address _lowerPartialRedemptionHint,
        uint256 _partialRedemptionHintNICR,
        uint256 _maxIterations,
        uint256 _maxFeePercentage
    ) external;

    function setAddresses(address _priceFeedAddress, address _sortedDensAddress, address _collateralToken) external;

    function setParameters(
        IFactory.DeploymentParams calldata _params
    ) external;

    function setPaused(bool _paused) external;

    function setPriceFeed(address _priceFeedAddress) external;

    function startSunset() external;

    function updateBalances() external;

    function updateDenFromAdjustment(
        bool _isDebtIncrease,
        uint256 _debtChange,
        uint256 _netDebtChange,
        bool _isCollIncrease,
        uint256 _collChange,
        address _upperHint,
        address _lowerHint,
        address _borrower,
        address _receiver
    ) external returns (uint256, uint256, uint256);

    function DEBT_GAS_COMPENSATION() external view returns (uint256);

    function DECIMAL_PRECISION() external view returns (uint256);

    function L_collateral() external view returns (uint256);

    function L_debt() external view returns (uint256);

    function MCR() external view returns (uint256);

    function PERCENT_DIVISOR() external view returns (uint256);

    function BERABORROW_CORE() external view returns (address);

    function SUNSETTING_INTEREST_RATE() external view returns (uint256);

    function Dens(
        address
    )
        external
        view
        returns (
            uint256 debt,
            uint256 coll,
            uint256 stake,
            uint8 status,
            uint128 arrayIndex,
            uint256 activeInterestIndex
        );

    function activeInterestIndex() external view returns (uint256);

    function baseRate() external view returns (uint256);

    function borrowerOperations() external view returns (address);

    function borrowingFeeFloor() external view returns (uint256);

    function collateralToken() external view returns (address);

    function debtToken() external view returns (address);

    function defaultedCollateral() external view returns (uint256);

    function defaultedDebt() external view returns (uint256);

    function getBorrowingFee(uint256 _debt) external view returns (uint256);

    function getBorrowingFeeWithDecay(uint256 _debt) external view returns (uint256);

    function getBorrowingRate() external view returns (uint256);

    function getBorrowingRateWithDecay() external view returns (uint256);

    function getCurrentICR(address _borrower, uint256 _price) external view returns (uint256);

    function getEntireDebtAndColl(
        address _borrower
    ) external view returns (uint256 debt, uint256 coll, uint256 pendingDebtReward, uint256 pendingCollateralReward);

    function getEntireSystemColl() external view returns (uint256);

    function getEntireSystemDebt() external view returns (uint256);

    function getNominalICR(address _borrower) external view returns (uint256);

    function getPendingCollAndDebtRewards(address _borrower) external view returns (uint256, uint256);

    function getRedemptionFeeWithDecay(uint256 _collateralDrawn) external view returns (uint256);

    function getRedemptionRate() external view returns (uint256);

    function getRedemptionRateWithDecay() external view returns (uint256);

    function getTotalActiveCollateral() external view returns (uint256);

    function getTotalActiveDebt() external view returns (uint256);

    function getDenCollAndDebt(address _borrower) external view returns (uint256 coll, uint256 debt);

    function getDenFromDenOwnersArray(uint256 _index) external view returns (address);

    function getDenOwnersCount() external view returns (uint256);

    function getDenStake(address _borrower) external view returns (uint256);

    function getDenStatus(address _borrower) external view returns (uint256);

    function guardian() external view returns (address);

    function hasPendingRewards(address _borrower) external view returns (bool);

    function interestPayable() external view returns (uint256);

    function interestRate() external view returns (uint256);

    function lastActiveIndexUpdate() external view returns (uint256);

    function lastCollateralError_Redistribution() external view returns (uint256);

    function lastDebtError_Redistribution() external view returns (uint256);

    function lastFeeOperationTime() external view returns (uint256);

    function liquidationManager() external view returns (address);

    function maxBorrowingFee() external view returns (uint256);

    function maxRedemptionFee() external view returns (uint256);

    function maxSystemDebt() external view returns (uint256);

    function minuteDecayFactor() external view returns (uint256);

    function owner() external view returns (address);

    function paused() external view returns (bool);

    function priceFeed() external view returns (address);

    function redemptionFeeFloor() external view returns (uint256);

    function rewardSnapshots(address) external view returns (uint256 collateral, uint256 debt);

    function sortedDens() external view returns (address);

    function sunsetting() external view returns (bool);

    function surplusBalances(address) external view returns (uint256);

    function systemDeploymentTime() external view returns (uint256);

    function totalCollateralSnapshot() external view returns (uint256);

    function totalStakes() external view returns (uint256);

    function totalStakesSnapshot() external view returns (uint256);

    function brimeDen() external view returns (address);
}

// lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol

// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// lib/openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Utils.sol

// OpenZeppelin Contracts (last updated v5.0.0) (proxy/ERC1967/ERC1967Utils.sol)

/**
 * @dev This abstract contract provides getters and event emitting update functions for
 * https://eips.ethereum.org/EIPS/eip-1967[ERC-1967] slots.
 */
library ERC1967Utils {
    /**
     * @dev Storage slot with the address of the current implementation.
     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1.
     */
    // solhint-disable-next-line private-vars-leading-underscore
    bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
     * @dev The `implementation` of the proxy is invalid.
     */
    error ERC1967InvalidImplementation(address implementation);

    /**
     * @dev The `admin` of the proxy is invalid.
     */
    error ERC1967InvalidAdmin(address admin);

    /**
     * @dev The `beacon` of the proxy is invalid.
     */
    error ERC1967InvalidBeacon(address beacon);

    /**
     * @dev An upgrade function sees `msg.value > 0` that may be lost.
     */
    error ERC1967NonPayable();

    /**
     * @dev Returns the current implementation address.
     */
    function getImplementation() internal view returns (address) {
        return StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value;
    }

    /**
     * @dev Stores a new address in the ERC-1967 implementation slot.
     */
    function _setImplementation(address newImplementation) private {
        if (newImplementation.code.length == 0) {
            revert ERC1967InvalidImplementation(newImplementation);
        }
        StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value = newImplementation;
    }

    /**
     * @dev Performs implementation upgrade with additional setup call if data is nonempty.
     * This function is payable only if the setup call is performed, otherwise `msg.value` is rejected
     * to avoid stuck value in the contract.
     *
     * Emits an {IERC1967-Upgraded} event.
     */
    function upgradeToAndCall(address newImplementation, bytes memory data) internal {
        _setImplementation(newImplementation);
        emit IERC1967.Upgraded(newImplementation);

        if (data.length > 0) {
            Address.functionDelegateCall(newImplementation, data);
        } else {
            _checkNonPayable();
        }
    }

    /**
     * @dev Storage slot with the admin of the contract.
     * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1.
     */
    // solhint-disable-next-line private-vars-leading-underscore
    bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    /**
     * @dev Returns the current admin.
     *
     * TIP: To get this value clients can read directly from the storage slot shown below (specified by ERC-1967) using
     * the https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
     * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
     */
    function getAdmin() internal view returns (address) {
        return StorageSlot.getAddressSlot(ADMIN_SLOT).value;
    }

    /**
     * @dev Stores a new address in the ERC-1967 admin slot.
     */
    function _setAdmin(address newAdmin) private {
        if (newAdmin == address(0)) {
            revert ERC1967InvalidAdmin(address(0));
        }
        StorageSlot.getAddressSlot(ADMIN_SLOT).value = newAdmin;
    }

    /**
     * @dev Changes the admin of the proxy.
     *
     * Emits an {IERC1967-AdminChanged} event.
     */
    function changeAdmin(address newAdmin) internal {
        emit IERC1967.AdminChanged(getAdmin(), newAdmin);
        _setAdmin(newAdmin);
    }

    /**
     * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
     * This is the keccak-256 hash of "eip1967.proxy.beacon" subtracted by 1.
     */
    // solhint-disable-next-line private-vars-leading-underscore
    bytes32 internal constant BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;

    /**
     * @dev Returns the current beacon.
     */
    function getBeacon() internal view returns (address) {
        return StorageSlot.getAddressSlot(BEACON_SLOT).value;
    }

    /**
     * @dev Stores a new beacon in the ERC-1967 beacon slot.
     */
    function _setBeacon(address newBeacon) private {
        if (newBeacon.code.length == 0) {
            revert ERC1967InvalidBeacon(newBeacon);
        }

        StorageSlot.getAddressSlot(BEACON_SLOT).value = newBeacon;

        address beaconImplementation = IBeacon(newBeacon).implementation();
        if (beaconImplementation.code.length == 0) {
            revert ERC1967InvalidImplementation(beaconImplementation);
        }
    }

    /**
     * @dev Change the beacon and trigger a setup call if data is nonempty.
     * This function is payable only if the setup call is performed, otherwise `msg.value` is rejected
     * to avoid stuck value in the contract.
     *
     * Emits an {IERC1967-BeaconUpgraded} event.
     *
     * CAUTION: Invoking this function has no effect on an instance of {BeaconProxy} since v5, since
     * it uses an immutable beacon without looking at the value of the ERC-1967 beacon slot for
     * efficiency.
     */
    function upgradeBeaconToAndCall(address newBeacon, bytes memory data) internal {
        _setBeacon(newBeacon);
        emit IERC1967.BeaconUpgraded(newBeacon);

        if (data.length > 0) {
            Address.functionDelegateCall(IBeacon(newBeacon).implementation(), data);
        } else {
            _checkNonPayable();
        }
    }

    /**
     * @dev Reverts if `msg.value` is not zero. It can be used to avoid `msg.value` stuck in the contract
     * if an upgrade doesn't perform an initialization call.
     */
    function _checkNonPayable() private {
        if (msg.value > 0) {
            revert ERC1967NonPayable();
        }
    }
}

// src/interfaces/core/IDebtToken.sol

 

interface IDebtToken is IERC20 {
    // --- Events ---
    event FlashLoanFeeUpdated(uint256 newFee);

    // --- Public constants ---
    function version() external view returns (string memory);
    function permitTypeHash() external view returns (bytes32);

    // --- Public immutables ---
    function gasPool() external view returns (address);
    function DEBT_GAS_COMPENSATION() external view returns (uint256);
    function PSMBond() external view returns (address);

    // --- Public mappings ---
    function liquidStabilityPools(address) external view returns (bool);
    function borrowerOperations(address) external view returns (bool);
    function factories(address) external view returns (bool);
    function peripheries(address) external view returns (bool);
    function denManagers(address) external view returns (bool);

    // --- External functions ---

    function enableDenManager(address _denManager) external;
    function mintWithGasCompensation(address _account, uint256 _amount) external returns (bool);
    function burnWithGasCompensation(address _account, uint256 _amount) external returns (bool);
    function mint(address _account, uint256 _amount) external;
    function burn(address _account, uint256 _amount) external;
    function decimals() external view returns (uint8);
    function sendToPeriphery(address _sender, uint256 _amount) external;
    function sendToSP(address _sender, uint256 _amount) external;
    function returnFromPool(address _poolAddress, address _receiver, uint256 _amount) external;
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function maxFlashLoan(address token) external view returns (uint256);
    function flashFee(address token, uint256 amount) external view returns (uint256);
    function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external returns (bool);
    function whitelistLiquidStabilityPoolAddress(address _liquidStabilityPool, bool active) external;
    function whitelistBorrowerOperationsAddress(address _borrowerOperations, bool active) external;
    function whitelistFactoryAddress(address _factory, bool active) external;
    function whitelistPeripheryAddress(address _periphery, bool active) external;
    function setDebtGasCompensation(uint256 _gasCompensation, bool _isFinalValue) external;
    function setFlashLoanFee(uint256 _fee) external;
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function permit(
        address owner,
        address spender,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
    function nonces(address owner) external view returns (uint256);
}

// lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/ERC20.sol)

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * The default value of {decimals} is 18. To change this, you should override
 * this function so it returns a different value.
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC-20
 * applications.
 */
abstract contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20, IERC20Metadata, IERC20Errors {
    /// @custom:storage-location erc7201:openzeppelin.storage.ERC20
    struct ERC20Storage {
        mapping(address account => uint256) _balances;

        mapping(address account => mapping(address spender => uint256)) _allowances;

        uint256 _totalSupply;

        string _name;
        string _symbol;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.ERC20")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant ERC20StorageLocation = 0x52c63247e1f47db19d5ce0460030c497f067ca4cebf71ba98eeadabe20bace00;

    function _getERC20Storage() private pure returns (ERC20Storage storage $) {
        assembly {
            $.slot := ERC20StorageLocation
        }
    }

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    function __ERC20_init(string memory name_, string memory symbol_) internal onlyInitializing {
        __ERC20_init_unchained(name_, symbol_);
    }

    function __ERC20_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
        ERC20Storage storage $ = _getERC20Storage();
        $._name = name_;
        $._symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        ERC20Storage storage $ = _getERC20Storage();
        return $._name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        ERC20Storage storage $ = _getERC20Storage();
        return $._symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the default value returned by this function, unless
     * it's overridden.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual returns (uint256) {
        ERC20Storage storage $ = _getERC20Storage();
        return $._totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual returns (uint256) {
        ERC20Storage storage $ = _getERC20Storage();
        return $._balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `value`.
     */
    function transfer(address to, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual returns (uint256) {
        ERC20Storage storage $ = _getERC20Storage();
        return $._allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `value` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, value);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Skips emitting an {Approval} event indicating an allowance update. This is not
     * required by the ERC. See {xref-ERC20-_approve-address-address-uint256-bool-}[_approve].
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `value`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `value`.
     */
    function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead.
     */
    function _transfer(address from, address to, uint256 value) internal {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, value);
    }

    /**
     * @dev Transfers a `value` amount of tokens from `from` to `to`, or alternatively mints (or burns) if `from`
     * (or `to`) is the zero address. All customizations to transfers, mints, and burns should be done by overriding
     * this function.
     *
     * Emits a {Transfer} event.
     */
    function _update(address from, address to, uint256 value) internal virtual {
        ERC20Storage storage $ = _getERC20Storage();
        if (from == address(0)) {
            // Overflow check required: The rest of the code assumes that totalSupply never overflows
            $._totalSupply += value;
        } else {
            uint256 fromBalance = $._balances[from];
            if (fromBalance < value) {
                revert ERC20InsufficientBalance(from, fromBalance, value);
            }
            unchecked {
                // Overflow not possible: value <= fromBalance <= totalSupply.
                $._balances[from] = fromBalance - value;
            }
        }

        if (to == address(0)) {
            unchecked {
                // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
                $._totalSupply -= value;
            }
        } else {
            unchecked {
                // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
                $._balances[to] += value;
            }
        }

        emit Transfer(from, to, value);
    }

    /**
     * @dev Creates a `value` amount of tokens and assigns them to `account`, by transferring it from address(0).
     * Relies on the `_update` mechanism
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead.
     */
    function _mint(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(address(0), account, value);
    }

    /**
     * @dev Destroys a `value` amount of tokens from `account`, lowering the total supply.
     * Relies on the `_update` mechanism.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead
     */
    function _burn(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        _update(account, address(0), value);
    }

    /**
     * @dev Sets `value` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     *
     * Overrides to this logic should be done to the variant with an additional `bool emitEvent` argument.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        _approve(owner, spender, value, true);
    }

    /**
     * @dev Variant of {_approve} with an optional flag to enable or disable the {Approval} event.
     *
     * By default (when calling {_approve}) the flag is set to true. On the other hand, approval changes made by
     * `_spendAllowance` during the `transferFrom` operation set the flag to false. This saves gas by not emitting any
     * `Approval` event during `transferFrom` operations.
     *
     * Anyone who wishes to continue emitting `Approval` events on the`transferFrom` operation can force the flag to
     * true using the following override:
     *
     * ```solidity
     * function _approve(address owner, address spender, uint256 value, bool) internal virtual override {
     *     super._approve(owner, spender, value, true);
     * }
     * ```
     *
     * Requirements are the same as {_approve}.
     */
    function _approve(address owner, address spender, uint256 value, bool emitEvent) internal virtual {
        ERC20Storage storage $ = _getERC20Storage();
        if (owner == address(0)) {
            revert ERC20InvalidApprover(address(0));
        }
        if (spender == address(0)) {
            revert ERC20InvalidSpender(address(0));
        }
        $._allowances[owner][spender] = value;
        if (emitEvent) {
            emit Approval(owner, spender, value);
        }
    }

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `value`.
     *
     * Does not update the allowance value in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Does not emit an {Approval} event.
     */
    function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            if (currentAllowance < value) {
                revert ERC20InsufficientAllowance(spender, currentAllowance, value);
            }
            unchecked {
                _approve(owner, spender, currentAllowance - value, false);
            }
        }
    }
}

// lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (proxy/utils/UUPSUpgradeable.sol)

/**
 * @dev An upgradeability mechanism designed for UUPS proxies. The functions included here can perform an upgrade of an
 * {ERC1967Proxy}, when this contract is set as the implementation behind such a proxy.
 *
 * A security mechanism ensures that an upgrade does not turn off upgradeability accidentally, although this risk is
 * reinstated if the upgrade retains upgradeability but removes the security mechanism, e.g. by replacing
 * `UUPSUpgradeable` with a custom implementation of upgrades.
 *
 * The {_authorizeUpgrade} function must be overridden to include access restriction to the upgrade mechanism.
 */
abstract contract UUPSUpgradeable is Initializable, IERC1822Proxiable {
    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable
    address private immutable __self = address(this);

    /**
     * @dev The version of the upgrade interface of the contract. If this getter is missing, both `upgradeTo(address)`
     * and `upgradeToAndCall(address,bytes)` are present, and `upgradeTo` must be used if no function should be called,
     * while `upgradeToAndCall` will invoke the `receive` function if the second argument is the empty byte string.
     * If the getter returns `"5.0.0"`, only `upgradeToAndCall(address,bytes)` is present, and the second argument must
     * be the empty byte string if no function should be called, making it impossible to invoke the `receive` function
     * during an upgrade.
     */
    string public constant UPGRADE_INTERFACE_VERSION = "5.0.0";

    /**
     * @dev The call is from an unauthorized context.
     */
    error UUPSUnauthorizedCallContext();

    /**
     * @dev The storage `slot` is unsupported as a UUID.
     */
    error UUPSUnsupportedProxiableUUID(bytes32 slot);

    /**
     * @dev Check that the execution is being performed through a delegatecall call and that the execution context is
     * a proxy contract with an implementation (as defined in ERC-1967) pointing to self. This should only be the case
     * for UUPS and transparent proxies that are using the current contract as their implementation. Execution of a
     * function through ERC-1167 minimal proxies (clones) would not normally pass this test, but is not guaranteed to
     * fail.
     */
    modifier onlyProxy() {
        _checkProxy();
        _;
    }

    /**
     * @dev Check that the execution is not being performed through a delegate call. This allows a function to be
     * callable on the implementing contract but not through proxies.
     */
    modifier notDelegated() {
        _checkNotDelegated();
        _;
    }

    function __UUPSUpgradeable_init() internal onlyInitializing {
    }

    function __UUPSUpgradeable_init_unchained() internal onlyInitializing {
    }
    /**
     * @dev Implementation of the ERC-1822 {proxiableUUID} function. This returns the storage slot used by the
     * implementation. It is used to validate the implementation's compatibility when performing an upgrade.
     *
     * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
     * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
     * function revert if invoked through a proxy. This is guaranteed by the `notDelegated` modifier.
     */
    function proxiableUUID() external view virtual notDelegated returns (bytes32) {
        return ERC1967Utils.IMPLEMENTATION_SLOT;
    }

    /**
     * @dev Upgrade the implementation of the proxy to `newImplementation`, and subsequently execute the function call
     * encoded in `data`.
     *
     * Calls {_authorizeUpgrade}.
     *
     * Emits an {Upgraded} event.
     *
     * @custom:oz-upgrades-unsafe-allow-reachable delegatecall
     */
    function upgradeToAndCall(address newImplementation, bytes memory data) public payable virtual onlyProxy {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallUUPS(newImplementation, data);
    }

    /**
     * @dev Reverts if the execution is not performed via delegatecall or the execution
     * context is not of a proxy with an ERC-1967 compliant implementation pointing to self.
     * See {_onlyProxy}.
     */
    function _checkProxy() internal view virtual {
        if (
            address(this) == __self || // Must be called through delegatecall
            ERC1967Utils.getImplementation() != __self // Must be called through an active proxy
        ) {
            revert UUPSUnauthorizedCallContext();
        }
    }

    /**
     * @dev Reverts if the execution is performed via delegatecall.
     * See {notDelegated}.
     */
    function _checkNotDelegated() internal view virtual {
        if (address(this) != __self) {
            // Must not be called through delegatecall
            revert UUPSUnauthorizedCallContext();
        }
    }

    /**
     * @dev Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
     * {upgradeToAndCall}.
     *
     * Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.
     *
     * ```solidity
     * function _authorizeUpgrade(address) internal onlyOwner {}
     * ```
     */
    function _authorizeUpgrade(address newImplementation) internal virtual;

    /**
     * @dev Performs an implementation upgrade with a security check for UUPS proxies, and additional setup call.
     *
     * As a security check, {proxiableUUID} is invoked in the new implementation, and the return value
     * is expected to be the implementation slot in ERC-1967.
     *
     * Emits an {IERC1967-Upgraded} event.
     */
    function _upgradeToAndCallUUPS(address newImplementation, bytes memory data) private {
        try IERC1822Proxiable(newImplementation).proxiableUUID() returns (bytes32 slot) {
            if (slot != ERC1967Utils.IMPLEMENTATION_SLOT) {
                revert UUPSUnsupportedProxiableUUID(slot);
            }
            ERC1967Utils.upgradeToAndCall(newImplementation, data);
        } catch {
            // The implementation is not UUPS
            revert ERC1967Utils.ERC1967InvalidImplementation(newImplementation);
        }
    }
}

// lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/ERC4626Upgradeable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/extensions/ERC4626.sol)

/**
 * @dev Implementation of the ERC-4626 "Tokenized Vault Standard" as defined in
 * https://eips.ethereum.org/EIPS/eip-4626[ERC-4626].
 *
 * This extension allows the minting and burning of "shares" (represented using the ERC-20 inheritance) in exchange for
 * underlying "assets" through standardized {deposit}, {mint}, {redeem} and {burn} workflows. This contract extends
 * the ERC-20 standard. Any additional extensions included along it would affect the "shares" token represented by this
 * contract and not the "assets" token which is an independent contract.
 *
 * [CAUTION]
 * ====
 * In empty (or nearly empty) ERC-4626 vaults, deposits are at high risk of being stolen through frontrunning
 * with a "donation" to the vault that inflates the price of a share. This is variously known as a donation or inflation
 * attack and is essentially a problem of slippage. Vault deployers can protect against this attack by making an initial
 * deposit of a non-trivial amount of the asset, such that price manipulation becomes infeasible. Withdrawals may
 * similarly be affected by slippage. Users can protect against this attack as well as unexpected slippage in general by
 * verifying the amount received is as expected, using a wrapper that performs these checks such as
 * https://github.com/fei-protocol/ERC4626#erc4626router-and-base[ERC4626Router].
 *
 * Since v4.9, this implementation introduces configurable virtual assets and shares to help developers mitigate that risk.
 * The `_decimalsOffset()` corresponds to an offset in the decimal representation between the underlying asset's decimals
 * and the vault decimals. This offset also determines the rate of virtual shares to virtual assets in the vault, which
 * itself determines the initial exchange rate. While not fully preventing the attack, analysis shows that the default
 * offset (0) makes it non-profitable even if an attacker is able to capture value from multiple user deposits, as a result
 * of the value being captured by the virtual shares (out of the attacker's donation) matching the attacker's expected gains.
 * With a larger offset, the attack becomes orders of magnitude more expensive than it is profitable. More details about the
 * underlying math can be found xref:erc4626.adoc#inflation-attack[here].
 *
 * The drawback of this approach is that the virtual shares do capture (a very small) part of the value being accrued
 * to the vault. Also, if the vault experiences losses, the users try to exit the vault, the virtual shares and assets
 * will cause the first user to exit to experience reduced losses in detriment to the last users that will experience
 * bigger losses. Developers willing to revert back to the pre-v4.9 behavior just need to override the
 * `_convertToShares` and `_convertToAssets` functions.
 *
 * To learn more, check out our xref:ROOT:erc4626.adoc[ERC-4626 guide].
 * ====
 */
abstract contract ERC4626Upgradeable is Initializable, ERC20Upgradeable, IERC4626 {
    using Math for uint256;

    /// @custom:storage-location erc7201:openzeppelin.storage.ERC4626
    struct ERC4626Storage {
        IERC20 _asset;
        uint8 _underlyingDecimals;
    }

    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.ERC4626")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant ERC4626StorageLocation = 0x0773e532dfede91f04b12a73d3d2acd361424f41f76b4fb79f090161e36b4e00;

    function _getERC4626Storage() private pure returns (ERC4626Storage storage $) {
        assembly {
            $.slot := ERC4626StorageLocation
        }
    }

    /**
     * @dev Attempted to deposit more assets than the max amount for `receiver`.
     */
    error ERC4626ExceededMaxDeposit(address receiver, uint256 assets, uint256 max);

    /**
     * @dev Attempted to mint more shares than the max amount for `receiver`.
     */
    error ERC4626ExceededMaxMint(address receiver, uint256 shares, uint256 max);

    /**
     * @dev Attempted to withdraw more assets than the max amount for `receiver`.
     */
    error ERC4626ExceededMaxWithdraw(address owner, uint256 assets, uint256 max);

    /**
     * @dev Attempted to redeem more shares than the max amount for `receiver`.
     */
    error ERC4626ExceededMaxRedeem(address owner, uint256 shares, uint256 max);

    /**
     * @dev Set the underlying asset contract. This must be an ERC20-compatible contract (ERC-20 or ERC-777).
     */
    function __ERC4626_init(IERC20 asset_) internal onlyInitializing {
        __ERC4626_init_unchained(asset_);
    }

    function __ERC4626_init_unchained(IERC20 asset_) internal onlyInitializing {
        ERC4626Storage storage $ = _getERC4626Storage();
        (bool success, uint8 assetDecimals) = _tryGetAssetDecimals(asset_);
        $._underlyingDecimals = success ? assetDecimals : 18;
        $._asset = asset_;
    }

    /**
     * @dev Attempts to fetch the asset decimals. A return value of false indicates that the attempt failed in some way.
     */
    function _tryGetAssetDecimals(IERC20 asset_) private view returns (bool, uint8) {
        (bool success, bytes memory encodedDecimals) = address(asset_).staticcall(
            abi.encodeCall(IERC20Metadata.decimals, ())
        );
        if (success && encodedDecimals.length >= 32) {
            uint256 returnedDecimals = abi.decode(encodedDecimals, (uint256));
            if (returnedDecimals <= type(uint8).max) {
                return (true, uint8(returnedDecimals));
            }
        }
        return (false, 0);
    }

    /**
     * @dev Decimals are computed by adding the decimal offset on top of the underlying asset's decimals. This
     * "original" value is cached during construction of the vault contract. If this read operation fails (e.g., the
     * asset has not been created yet), a default of 18 is used to represent the underlying asset's decimals.
     *
     * See {IERC20Metadata-decimals}.
     */
    function decimals() public view virtual override(IERC20Metadata, ERC20Upgradeable) returns (uint8) {
        ERC4626Storage storage $ = _getERC4626Storage();
        return $._underlyingDecimals + _decimalsOffset();
    }

    /** @dev See {IERC4626-asset}. */
    function asset() public view virtual returns (address) {
        ERC4626Storage storage $ = _getERC4626Storage();
        return address($._asset);
    }

    /** @dev See {IERC4626-totalAssets}. */
    function totalAssets() public view virtual returns (uint256) {
        ERC4626Storage storage $ = _getERC4626Storage();
        return $._asset.balanceOf(address(this));
    }

    /** @dev See {IERC4626-convertToShares}. */
    function convertToShares(uint256 assets) public view virtual returns (uint256) {
        return _convertToShares(assets, Math.Rounding.Down);
    }

    /** @dev See {IERC4626-convertToAssets}. */
    function convertToAssets(uint256 shares) public view virtual returns (uint256) {
        return _convertToAssets(shares, Math.Rounding.Down);
    }

    /** @dev See {IERC4626-maxDeposit}. */
    function maxDeposit(address) public view virtual returns (uint256) {
        return type(uint256).max;
    }

    /** @dev See {IERC4626-maxMint}. */
    function maxMint(address) public view virtual returns (uint256) {
        return type(uint256).max;
    }

    /** @dev See {IERC4626-maxWithdraw}. */
    function maxWithdraw(address owner) public view virtual returns (uint256) {
        return _convertToAssets(balanceOf(owner), Math.Rounding.Down);
    }

    /** @dev See {IERC4626-maxRedeem}. */
    function maxRedeem(address owner) public view virtual returns (uint256) {
        return balanceOf(owner);
    }

    /** @dev See {IERC4626-previewDeposit}. */
    function previewDeposit(uint256 assets) public view virtual returns (uint256) {
        return _convertToShares(assets, Math.Rounding.Down);
    }

    /** @dev See {IERC4626-previewMint}. */
    function previewMint(uint256 shares) public view virtual returns (uint256) {
        return _convertToAssets(shares, Math.Rounding.Up);
    }

    /** @dev See {IERC4626-previewWithdraw}. */
    function previewWithdraw(uint256 assets) public view virtual returns (uint256) {
        return _convertToShares(assets, Math.Rounding.Up);
    }

    /** @dev See {IERC4626-previewRedeem}. */
    function previewRedeem(uint256 shares) public view virtual returns (uint256) {
        return _convertToAssets(shares, Math.Rounding.Down);
    }

    /** @dev See {IERC4626-deposit}. */
    function deposit(uint256 assets, address receiver) public virtual returns (uint256) {
        uint256 maxAssets = maxDeposit(receiver);
        if (assets > maxAssets) {
            revert ERC4626ExceededMaxDeposit(receiver, assets, maxAssets);
        }

        uint256 shares = previewDeposit(assets);
        _deposit(_msgSender(), receiver, assets, shares);

        return shares;
    }

    /** @dev See {IERC4626-mint}. */
    function mint(uint256 shares, address receiver) public virtual returns (uint256) {
        uint256 maxShares = maxMint(receiver);
        if (shares > maxShares) {
            revert ERC4626ExceededMaxMint(receiver, shares, maxShares);
        }

        uint256 assets = previewMint(shares);
        _deposit(_msgSender(), receiver, assets, shares);

        return assets;
    }

    /** @dev See {IERC4626-withdraw}. */
    function withdraw(uint256 assets, address receiver, address owner) public virtual returns (uint256) {
        uint256 maxAssets = maxWithdraw(owner);
        if (assets > maxAssets) {
            revert ERC4626ExceededMaxWithdraw(owner, assets, maxAssets);
        }

        uint256 shares = previewWithdraw(assets);
        _withdraw(_msgSender(), receiver, owner, assets, shares);

        return shares;
    }

    /** @dev See {IERC4626-redeem}. */
    function redeem(uint256 shares, address receiver, address owner) public virtual returns (uint256) {
        uint256 maxShares = maxRedeem(owner);
        if (shares > maxShares) {
            revert ERC4626ExceededMaxRedeem(owner, shares, maxShares);
        }

        uint256 assets = previewRedeem(shares);
        _withdraw(_msgSender(), receiver, owner, assets, shares);

        return assets;
    }

    /**
     * @dev Internal conversion function (from assets to shares) with support for rounding direction.
     */
    // Deposit 1 USDC
    // 1e6 * 1e12 / 1 -> 1e18 shares minted
    // Deposit 1 USDC after first mint
    // 1e6 * 1e18 / 1e18 -> 1e6 shares minted

    // After first mint, BaseCollVault correctly does:
    // 1e6 * 1e18 / 1e6 -> 1e18 shares minted

    // Problem is usdValue in `totalAssets will have to be multiplied in 10 ** decimal precision, instead of WAD:
    // Currently: `amountInAsset = usdValue.mulDiv(WAD, assetPrice) + assetBalanceWad;`
    // Fix: `amountInAsset = usdValue.mulDiv(assetDecimals(), assetPrice) + assetBalance;`
    // Which reduces precision in totalAsset.
    // We could fix it by overriding deposit/mint/withdraw/redeem to scale internally assets to WAD, but leads to higher complexity

    // 8 decimals
    // 1e8 * 1e10 / 1 = 1e18 minted shares
    // 1e8 * 1e18 / 1e8 = 1e18 minted shares

    function _convertToShares(uint256 assets, Math.Rounding rounding) internal view virtual returns (uint256) {
        return assets.mulDiv(totalSupply() + 10 ** _decimalsOffset(), totalAssets() + 1, rounding);
    }

    /**
     * @dev Internal conversion function (from shares to assets) with support for rounding direction.
     */
    function _convertToAssets(uint256 shares, Math.Rounding rounding) internal view virtual returns (uint256) {
        return shares.mulDiv(totalAssets() + 1, totalSupply() + 10 ** _decimalsOffset(), rounding);
    }

    /**
     * @dev Deposit/mint common workflow.
     */
    function _deposit(address caller, address receiver, uint256 assets, uint256 shares) internal virtual {
        ERC4626Storage storage $ = _getERC4626Storage();
        // If _asset is ERC-777, `transferFrom` can trigger a reentrancy BEFORE the transfer happens through the
        // `tokensToSend` hook. On the other hand, the `tokenReceived` hook, that is triggered after the transfer,
        // calls the vault, which is assumed not malicious.
        //
        // Conclusion: we need to do the transfer before we mint so that any reentrancy would happen before the
        // assets are transferred and before the shares are minted, which is a valid state.
        // slither-disable-next-line reentrancy-no-eth
        SafeERC20.safeTransferFrom($._asset, caller, address(this), assets);
        _mint(receiver, shares);

        emit Deposit(caller, receiver, assets, shares);
    }

    /**
     * @dev Withdraw/redeem common workflow.
     */
    function _withdraw(
        address caller,
        address receiver,
        address owner,
        uint256 assets,
        uint256 shares
    ) internal virtual {
        ERC4626Storage storage $ = _getERC4626Storage();
        if (caller != owner) {
            _spendAllowance(owner, caller, shares);
        }

        // If _asset is ERC-777, `transfer` can trigger a reentrancy AFTER the transfer happens through the
        // `tokensReceived` hook. On the other hand, the `tokensToSend` hook, that is triggered before the transfer,
        // calls the vault, which is assumed not malicious.
        //
        // Conclusion: we need to do the transfer after the burn so that any reentrancy would happen after the
        // shares are burned and after the assets are transferred, which is a valid state.
        _burn(owner, shares);
        SafeERC20.safeTransfer($._asset, receiver, assets);

        emit Withdraw(caller, receiver, owner, assets, shares);
    }

    function _decimalsOffset() internal view virtual returns (uint8) {
        return 0;
    }
}

// src/libraries/EmissionsLib.sol

library EmissionsLib {
    using SafeCast for uint256;
    uint64 constant internal DEFAULT_UNLOCK_RATE = 1e11; // 10% per second
    uint64 constant internal MAX_UNLOCK_RATE = 1e12; // 100%

    struct BalanceData {
        mapping(address token => uint) balance;
        mapping(address token => EmissionSchedule) emissionSchedule;
    }

    struct EmissionSchedule {
        uint128 emissions;
        uint64 lockTimestamp;
        uint64 _unlockRatePerSecond; // rate points
    }

    error AmountCannotBeZero();
    error EmissionRateExceedsMax();
    // error UnsupportedEmissionConfig();

    event EmissionsAdded(address indexed token, uint128 amount);
    event EmissionsSub(address indexed token, uint128 amount);
    event NewUnlockRatePerSecond(address indexed token, uint64 unlockRatePerSecond);

    /// @dev zero _unlockRatePerSecond parameter resets rate back to DEFAULT_UNLOCK_RATE
    function setUnlockRatePerSecond(BalanceData storage $, address token, uint64 _unlockRatePerSecond) internal {
        if (_unlockRatePerSecond > MAX_UNLOCK_RATE) revert EmissionRateExceedsMax();
        _addEmissions($, token, 0); // update lockTimestamp and emissions
        $.emissionSchedule[token]._unlockRatePerSecond = _unlockRatePerSecond;

        emit NewUnlockRatePerSecond(token, _unlockRatePerSecond);
    }

    function addEmissions(BalanceData storage $, address token, uint128 amount) internal {
        if (amount == 0) revert AmountCannotBeZero();
        _addEmissions($, token, amount);

        emit EmissionsAdded(token, amount);
    }

    function _addEmissions(BalanceData storage $, address token, uint128 amount) private {        
        EmissionSchedule memory schedule = $.emissionSchedule[token];

        uint256 _unlockTimestamp = unlockTimestamp(schedule);
        uint128 nextEmissions = (lockedEmissions(schedule, _unlockTimestamp) + amount).toUint128();

        schedule.emissions = nextEmissions;
        schedule.lockTimestamp = block.timestamp.toUint64();
        $.balance[token] += amount;

        $.emissionSchedule[token] = schedule;
    }

    function subEmissions(BalanceData storage $, address token, uint128 amount) internal {
        if (amount == 0) revert AmountCannotBeZero();
        _subEmissions($, token, amount);

        emit EmissionsSub(token, amount);
    }

    function _subEmissions(BalanceData storage $, address token, uint128 amount) private {
        EmissionSchedule memory schedule = $.emissionSchedule[token];

        uint256 _unlockTimestamp = unlockTimestamp(schedule);
        uint128 nextEmissions = (lockedEmissions(schedule, _unlockTimestamp) - amount).toUint128();

        schedule.emissions = nextEmissions;
        schedule.lockTimestamp = block.timestamp.toUint64();
        $.balance[token] -= amount;

        $.emissionSchedule[token] = schedule;
    }

    /// @dev Doesn't include locked emissions
    function unlockedEmissions(EmissionSchedule memory schedule) internal view returns (uint256) {
        return schedule.emissions - lockedEmissions(schedule, unlockTimestamp(schedule));
    }

    function balanceOfWithFutureEmissions(BalanceData storage $, address token) internal view returns (uint256) {
        return $.balance[token];
    }

    /**
     * @notice Returns the unlocked token emissions
     */
    function balanceOf(BalanceData storage $, address token) internal view returns (uint256) {
        EmissionSchedule memory schedule = $.emissionSchedule[token];
        return $.balance[token] - lockedEmissions(schedule, unlockTimestamp(schedule));
    }

    /**
     * @notice Returns locked emissions
     */
    function lockedEmissions(EmissionSchedule memory schedule, uint256 _unlockTimestamp) internal view returns (uint256) {
        if (block.timestamp >= _unlockTimestamp) {
            // all emissions were unlocked 
            return 0;
        } else {
            // emissions are still unlocking, calculate the amount of already unlocked emissions
            uint256 secondsSinceLockup = block.timestamp - schedule.lockTimestamp;
            // design decision - use dimensionless 'unlock rate units' to unlock emissions over a fixed time window 
            uint256 ratePointsUnlocked = unlockRatePerSecond(schedule) * secondsSinceLockup;
            // emissions remainder is designed to be added to balance in unlockTimestamp
            return schedule.emissions - ratePointsUnlocked * schedule.emissions / MAX_UNLOCK_RATE;
        }
    } 

    // timestamp at which all emissions are fully unlocked
    function unlockTimestamp(EmissionSchedule memory schedule) internal pure returns (uint256) {
        // ceil to account for remainder seconds left after integer division
        return divRoundUp(MAX_UNLOCK_RATE, unlockRatePerSecond(schedule)) + schedule.lockTimestamp; 
    }

    function unlockRatePerSecond(EmissionSchedule memory schedule) internal pure returns (uint256) {
        return schedule._unlockRatePerSecond == 0 ? DEFAULT_UNLOCK_RATE : schedule._unlockRatePerSecond;
    }

    function divRoundUp(uint256 dividend, uint256 divisor) internal pure returns (uint256) {
        return (dividend + divisor - 1) / divisor;
    }
}

// src/interfaces/core/ILiquidStabilityPool.sol

interface ILiquidStabilityPool is IERC4626, IERC1822Proxiable {
    struct LSPStorage {
        IMetaBeraborrowCore metaBeraborrowCore;
        address feeReceiver;
        /// @notice Array of tokens that have been emitted to the LiquidStabilityPool
        /// @notice Used to track which tokens can be withdrawn to LSP share holders
        /// @dev Doesn't include tokens that are already BeraBorrow's collaterals
        EnumerableSet.AddressSet extraAssets;
        Queue queue;
        address[] collateralTokens;
        mapping(uint16 => SunsetIndex) _sunsetIndexes;
        mapping(address collateral => uint256 index) indexByCollateral;
        mapping(bytes32 => uint) threshold;
        EmissionsLib.BalanceData balanceData;
        mapping(address => bool) factoryProtocol;
        mapping(address => bool) liquidationManagerProtocol;
        // Allowed to withdraw their positions during bootstrap period
        mapping(address => bool) boycoVault;
    }

    struct InitParams {
        IERC20 _asset;
        string _sharesName;
        string _sharesSymbol;
        IMetaBeraborrowCore _metaBeraborrowCore;
        address _liquidationManager;
        address _factory;
        address _feeReceiver;
    }

    struct RebalanceParams {
        address sentCurrency;
        uint sentAmount;
        address receivedCurrency;
        address swapper;
        bytes payload;
    }

    struct SunsetIndex {
        uint128 idx;
        uint128 expiry;
    }

    struct Queue {
        uint16 firstSunsetIndexKey;
        uint16 nextSunsetIndexKey;
    }

    event CollAndEmissionsWithdraw(
        address indexed receiver,
        uint shares,
        uint[] amounts
    );

    struct Arrays {
        uint length;
        address[] collaterals;
        uint collateralsLength;
        uint[] amounts;
    }

    event EmissionTokenAdded(address token);
    event EmissionTokenRemoved(address token);
    event StabilityPoolDebtBalanceUpdated(uint256 newBalance);
    event UserDepositChanged(address indexed depositor, uint256 newDeposit);
    event CollateralOverwritten(address oldCollateral, address newCollateral);

    // PROXY
    function upgradeToAndCall(address newImplementation, bytes calldata data) external;
    function getCurrentImplementation() external view returns (address);

    function SUNSET_DURATION() external view returns (uint128);
    function totalDebtTokenDeposits() external view returns (uint256);
    function enableCollateral(address _collateral, uint64 _unlockRatePerSecond, bool forceThroughBalanceCheck) external;
    function startCollateralSunset(address collateral) external;
    function getTotalDebtTokenDeposits() external view returns (uint256);
    function getCollateralTokens() external view returns (address[] memory);
    function offset(address collateral, uint256 _debtToOffset, uint256 _collToAdd) external;
    function initialize(InitParams calldata params) external;
    function rebalance(RebalanceParams calldata p) external;
    function linearVestingExtraAssets(address token, int amount, address recipient) external;
    function withdraw(
        uint assets,
        address[] calldata preferredUnderlyingTokens,
        address receiver,
        address _owner
    ) external returns (uint shares);
    function redeem(
        uint shares,
        address[] calldata preferredUnderlyingTokens,
        address receiver,
        address _owner
    ) external returns (uint assets);
    function updateProtocol(
        address _liquidationManager, 
        address _factory,
        bool _register
    ) external;
    function addNewExtraAsset(address token, uint64 _unlockRatePerSecond) external;
    function removeEmitedTokens(address token) external;
    function setPairThreshold(address tokenIn, address tokenOut, uint thresholdInBP) external;
    function setUnlockRatePerSecond(address token, uint64 _unlockRatePerSecond) external;
    function getPrice(address token) external view returns (uint);
    function getLockedEmissions(address token) external view returns (uint);
    function extSloads(bytes32[] calldata slots) external view returns (bytes32[] memory res);
    function unlockRatePerSecond(address token) external view returns (uint);
    function removeExtraAsset(address token) external;
}

// src/interfaces/core/vaults/IBaseCollateralVault.sol

interface IBaseCollateralVault is IERC4626, IERC1822Proxiable {
    struct BaseInitParams {
        uint16 _minWithdrawFee;
        uint16 _maxWithdrawFee;
        uint16 _withdrawFee;
        IMetaBeraborrowCore _metaBeraborrowCore;
        // ERC4626
        IERC20 _asset;
        // ERC20
        string _sharesName;
        string _sharesSymbol;
    }

    struct BaseCollVaultStorage {
        uint16 minWithdrawFee;
        uint16 maxWithdrawFee;
        uint16 withdrawFee; // over rewarded tokens, in basis points
        uint8 assetDecimals;

        IMetaBeraborrowCore _metaBeraborrowCore;

        // Second mapping of this struct is usless, but it's for retrocompatibility with InfraredCollateralVault
        EmissionsLib.BalanceData balanceData;
    }

    function totalAssets() external view returns (uint);

    function fetchPrice() external view returns (uint);

    function getPrice(address token) external view returns (uint);

    function receiveDonations(address[] memory tokens, uint[] memory amounts, address receiver) external;

    function setWithdrawFee(uint16 _withdrawFee) external;

    function getBalance(address token) external view returns (uint);

    function getWithdrawFee() external view returns (uint16);

    function getMetaBeraborrowCore() external view returns (IMetaBeraborrowCore);

    function getPriceFeed() external view returns (IPriceFeed);

    function assetDecimals() external view returns (uint8);
}

// src/interfaces/core/vaults/IInfraredCollateralVault.sol

interface IInfraredCollateralVault is IBaseCollateralVault {
    struct InfraredCollVaultStorage {
        uint16 minPerformanceFee;
        uint16 maxPerformanceFee;
        uint16 performanceFee; // over yield, in basis points
        address iRedToken;
        /// @dev We currently don't know the infraredVault implementation, but if it were to be possible for them to remove tokens from the rewardTokens
        /// There would be no need to remove it from here since the amounts should continue being accounted for in the virtual balance
        EnumerableSet.AddressSet rewardedTokens;

        IInfraredVault _infraredVault;
        address ibgtVault;
        address ibgt;
        IInfraredWrapper infraredWrapper;
        uint96 lastUpdate;

        mapping(address tokenIn => uint) threshold;
    }

    struct InfraredInitParams {
        BaseInitParams _baseParams;
        uint16 _minPerformanceFee;
        uint16 _maxPerformanceFee;
        uint16 _performanceFee; // over yield, in basis points
        address _iRedToken;
        IInfraredVault _infraredVault;
        address _ibgtVault;
        address _infraredWrapper;
    }

    struct RebalanceParams {
        address sentCurrency; 
        uint sentAmount; 
        address swapper;
        bytes payload;
    }

    function rebalance(RebalanceParams calldata p) external;

    function setUnlockRatePerSecond(address token, uint64 _unlockRatePerSecond) external;

    function internalizeDonations(address[] memory tokens, uint128[] memory amounts) external;

    function setPairThreshold(address tokenIn, uint thresholdInBP) external;

    function setPerformanceFee(uint16 _performanceFee) external;
    function setWithdrawFee(uint16 _withdrawFee) external;

    function getBalance(address token) external view returns (uint);

    function getBalanceOfWithFutureEmissions(address token) external view returns (uint);

    function getFullProfitUnlockTimestamp(address token) external view returns (uint);

    function unlockRatePerSecond(address token) external view returns (uint);

    function getLockedEmissions(address token) external view returns (uint);

    function getPerformanceFee() external view returns (uint16);

    function rewardedTokens() external view returns (address[] memory);

    function iRedToken() external view returns (address);

    function infraredVault() external view returns (IInfraredVault);

    function ibgt() external view returns (address);

    function ibgtVault() external view returns (address);
}

// src/interfaces/core/vaults/IIBGTVault.sol

interface IIBGTVault is IInfraredCollateralVault {
    /*
    struct IBGTVaultStorage {
        IInfraredVault infraredIBGTVault;
    }

    struct InitParams {
        IInfraredVault _infraredIBGTVault;
    }
    */

    function initialize(IInfraredCollateralVault.InfraredInitParams calldata baseParams /*, InitParams calldata ibgtParams */) external;
    function setInfraredVault(address _infraredVault) external;
    function upgradeToAndCall(address newImplementation, bytes calldata data) external;
}

// src/core/vaults/BaseCollateralVault.sol

 

abstract contract BaseCollateralVault is ERC4626Upgradeable, UUPSUpgradeable, IBaseCollateralVault {
    using Math for uint;
    using SafeERC20 for IERC20;
    using FeeLib for uint;

    uint internal constant BP = 1e4;

    // keccak256(abi.encode(uint(keccak256("openzeppelin.storage.BaseCollateralVault")) - 1)) & ~bytes32(uint(0xff))
    bytes32 private constant BaseCollateralVaultStorageLocation = 0x19001df2d131e9aa1479f4ce661ae121445caf0662dea1e41907028a6da6fe00;

    function _getBaseCollVaultStorage() internal pure returns (BaseCollVaultStorage storage store) {
        assembly {
            store.slot := BaseCollateralVaultStorageLocation
        }
    }

    constructor() {
        _disableInitializers();
    }

    function __BaseCollateralVault_init(BaseInitParams calldata params) internal onlyInitializing {
        __BaseCollateralVault_init_unchained(params);
    }

    function __BaseCollateralVault_init_unchained(BaseInitParams calldata params) internal onlyInitializing {
        BaseCollVaultStorage storage $ = _getBaseCollVaultStorage();

        if (address(params._metaBeraborrowCore) == address(0) || address(params._asset) == address(0)) {
            revert("CollVault: 0 address");
        }

        IPriceFeed priceFeed = IPriceFeed(params._metaBeraborrowCore.priceFeed());
        require(priceFeed.fetchPrice(address(params._asset)) != 0, "CollVault: asset price feed not set up");
        require(params._minWithdrawFee <= params._maxWithdrawFee && params._maxWithdrawFee <= BP, "CollVault: Incorrect min/max withdraw fee");
        require(params._withdrawFee >= params._minWithdrawFee && params._withdrawFee <= params._maxWithdrawFee, "CollVault: withdraw fee out of bounds");

        $.minWithdrawFee = params._minWithdrawFee;
        $.maxWithdrawFee = params._maxWithdrawFee;

        $.withdrawFee = params._withdrawFee;

        uint8 _assetDecimals = IAsset(address(params._asset)).decimals();
        if (_assetDecimals > 18) {
            revert("CollVault: asset decimals > 18");
        }
        $.assetDecimals = _assetDecimals;

        $._metaBeraborrowCore = params._metaBeraborrowCore;

        __ERC20_init(params._sharesName, params._sharesSymbol);
        __ERC4626_init(params._asset);
    }

    modifier onlyOwner {
        _onlyOwner();
        _;
    }

    modifier harvestRewards() {
        _harvestRewards();
        _;
    }

    function _onlyOwner() private view {
        // Owner is beacon variable MetaBeraborrowCore::owner()
        require(msg.sender == getMetaBeraborrowCore().owner(), "CollVault: caller is not the owner");
    }

    function _authorizeUpgrade(address newImplementation) internal override virtual onlyOwner {}

    /** @dev See {IERC4626-totalAssets}. */
    /// @notice Returns the total assets in the vault, denominated in the asset of the vault
    /// @dev Virtual accounting to avoid donations, asset valued denomination, returned in asset decimals
    function totalAssets() public view override(ERC4626Upgradeable, IBaseCollateralVault) virtual returns (uint) {
        return getBalance(asset());
    }

    /// @dev Called by DenManager, returns the share usd value in WAD
    /// @dev Fees are not accounted to downprice the share value for redeemCollateral,
    ///     for borrowing, MCR will account for this downprice 
    function fetchPrice() public view virtual returns (uint) {
        uint _totalSupply = totalSupply();
        if (_totalSupply == 0) return 0;
        return (totalAssets() * 10 ** _decimalsOffset()).mulDiv(getPrice(asset()), _totalSupply);
    }

    /// @dev Note, validate this implementation if inherited by multi asset vault (InfraredCollateralVault)
    function _decimalsOffset() internal view override virtual returns (uint8) {
        return 18 - assetDecimals();
    }

    function deposit(
        uint assets,
        address receiver
    ) public override(ERC4626Upgradeable, IERC4626) harvestRewards returns (uint shares) {
        shares = super.deposit(assets, receiver);

        _stake(assets);

        _increaseBalance(asset(), assets);
    }

    function mint(
        uint shares,
        address receiver
    ) public override(ERC4626Upgradeable, IERC4626) harvestRewards returns (uint assets) {
        assets = super.mint(shares, receiver);

        _stake(assets);

        _increaseBalance(asset(), assets);
    }

    function withdraw(
        uint assets,
        address receiver,
        address _owner
    ) public override(ERC4626Upgradeable, IERC4626) harvestRewards returns (uint shares) {
        uint _totalSupply = totalSupply(); // cached to don't account for the burn

        { // scope to avoid stack too deep error
            uint256 maxAssets = maxWithdraw(_owner);
            if (assets > maxAssets) {
                revert ERC4626ExceededMaxWithdraw(_owner, assets, maxAssets);
            }
        }
        uint shareFee;
        (shares, shareFee) = _previewWithdraw(assets);

        (uint assetAmount, uint netShares) = _applyShareFee(shares, _totalSupply, shareFee);

        if (assetAmount != 0) {
            _unstake(assetAmount);
            _decreaseBalance(asset(), assetAmount);
        }

        _withdraw(msg.sender, receiver, _owner, assetAmount, shares);
        _withdrawExtraRewardedTokens(receiver, netShares, _totalSupply);
    }

    /// @dev Decompounded redeem() function to reuse `previewRedeem()` on `infrared.withdraw`
    function redeem(
        uint shares,
        address receiver,
        address _owner
    ) public override(ERC4626Upgradeable, IERC4626) harvestRewards returns (uint assets) {
        uint _totalSupply = totalSupply(); // cached to don't account for the burn

        { // scope to avoid stack too deep error
            uint256 maxShares = maxRedeem(_owner);
            if (shares > maxShares) {
                revert ERC4626ExceededMaxRedeem(_owner, shares, maxShares);
            }
        }

        uint shareFee;
        (assets, shareFee) = _previewRedeem(shares);

        (uint assetAmount, uint netShares) = _applyShareFee(shares, _totalSupply, shareFee);

        if (assetAmount != 0) {
            _unstake(assetAmount);
            _decreaseBalance(asset(), assetAmount);
        }

        _withdraw(msg.sender, receiver, _owner, assetAmount, shares);
        _withdrawExtraRewardedTokens(receiver, netShares, _totalSupply);
    }

    function _applyShareFee(uint shares, uint _totalSupply, uint fee) internal virtual returns (uint, uint) {
        BaseCollVaultStorage storage $ = _getBaseCollVaultStorage();

        uint netShares = shares - fee;

        uint assetAmount = netShares.mulDiv(getBalance(asset()), _totalSupply, Math.Rounding.Down);

        address feeReceiver = $._metaBeraborrowCore.feeReceiver();
        if (fee != 0) {
            _mint(feeReceiver, fee);
        }

        return (assetAmount, netShares);
    }

    /// @dev Preview adding an exit fee on withdraw. See {IERC4626-previewWithdraw}.
    function previewWithdraw(
        uint assets
    ) public view virtual override(ERC4626Upgradeable, IERC4626) returns (uint) {
        (uint totalShares,) = _previewWithdraw(assets);
        return totalShares;
    }

    function _previewWithdraw(uint assets) internal view virtual returns (uint, uint) {
        BaseCollVaultStorage storage $ = _getBaseCollVaultStorage();

        uint netShares = super.previewWithdraw(assets);
        uint totalShares = netShares.mulDiv(BP, BP - $.withdrawFee, Math.Rounding.Up);
        uint shareFee = totalShares - netShares;
        return (totalShares, shareFee);
    }

    /// @dev Preview taking an exit fee on redeem. See {IERC4626-previewRedeem}.
    function previewRedeem(
        uint shares
    ) public view virtual override(ERC4626Upgradeable, IERC4626) returns (uint) {
        (uint assets,) = _previewRedeem(shares);
        return assets;
    }

    function _previewRedeem(uint shares) internal view virtual returns (uint, uint) {
        BaseCollVaultStorage storage $ = _getBaseCollVaultStorage();

        uint shareFee = shares.feeOnRaw($.withdrawFee);
        uint assets = super.previewRedeem(shares - shareFee);
        return (assets, shareFee);
    }

    /** @dev See {IERC4626-maxWithdraw}. */
    function maxWithdraw(address _owner) public view override(ERC4626Upgradeable, IERC4626) returns (uint) {
        return previewRedeem(balanceOf(_owner));
    }

    /// @dev `receiver` automatically receives `asset()` donations, and `tokens` and `amounts` donations as desired by the owner `amounts`
    function receiveDonations(address[] memory tokens, uint[] memory amounts, address receiver) external virtual onlyOwner {
        BaseCollVaultStorage storage $ = _getBaseCollVaultStorage();

        uint tokensLength = tokens.length;

        require(tokensLength == amounts.length, "CollVault: tokens and amounts length mismatch");

        uint assetBalance = IERC20(asset()).balanceOf(address(this));
        uint virtualBalance = $.balanceData.balance[asset()];

        if (assetBalance > virtualBalance) {
            IERC20(asset()).safeTransfer(receiver, assetBalance - virtualBalance);
        }

        for (uint i; i < tokensLength; i++) {
            if (tokens[i] == asset()) {
                continue;
            }
            uint256 tokenBalance = IERC20(tokens[i]).balanceOf(address(this));
            uint256 virtualTokenBalance = $.balanceData.balance[tokens[i]];
            uint256 transferAmount = Math.min(amounts[i], tokenBalance - virtualTokenBalance);
            if (transferAmount > 0) {
                IERC20(tokens[i]).safeTransfer(receiver, transferAmount);
            }
        }
    }

    function setWithdrawFee(uint16 _withdrawFee) external virtual onlyOwner {
        BaseCollVaultStorage storage $ = _getBaseCollVaultStorage();

        require(_withdrawFee >= $.minWithdrawFee && _withdrawFee <= $.maxWithdrawFee, "CollVault: Withdraw fee out of bounds");

        $.withdrawFee = _withdrawFee;
    }

    function _increaseBalance(address token, uint amount) internal virtual {
        BaseCollVaultStorage storage $ = _getBaseCollVaultStorage();
        $.balanceData.balance[token] += amount;
    }

    function _decreaseBalance(address token, uint amount) internal virtual {
        BaseCollVaultStorage storage $ = _getBaseCollVaultStorage();
        $.balanceData.balance[token] -= amount;
    }

    function _getBalanceData() internal view virtual returns (EmissionsLib.BalanceData storage) {
        return _getBaseCollVaultStorage().balanceData;
    }

    function getPrice(
        address token
    ) public view virtual returns (uint) {
        return getPriceFeed().fetchPrice(token);
    }

    function getBalance(address token) public view virtual returns (uint) {
        return _getBaseCollVaultStorage().balanceData.balance[token];
    }

    function getWithdrawFee() public view virtual returns (uint16) {
        return _getBaseCollVaultStorage().withdrawFee;
    }

    function getMetaBeraborrowCore() public view virtual returns (IMetaBeraborrowCore) {
        return _getBaseCollVaultStorage()._metaBeraborrowCore;
    }

    function getPriceFeed() public view virtual returns (IPriceFeed) {
        return IPriceFeed(_getBaseCollVaultStorage()._metaBeraborrowCore.priceFeed());
    }

    function assetDecimals() public view virtual returns (uint8) {
        return _getBaseCollVaultStorage().assetDecimals;
    }

    function _harvestRewards() internal virtual {}
    function _stake(uint amount) internal virtual {}
    function _unstake(uint amount) internal virtual {}
    function _withdrawExtraRewardedTokens(address receiver, uint netShares, uint _totalSupply) internal virtual {}
}

// src/core/vaults/InfraredCollateralVault.sol

/**
 * @title Beraborrow Infrared Collateral Vault
 * @notice Supercharges DenManager with PoL
 */
abstract contract InfraredCollateralVault is BaseCollateralVault {
    using Math for uint;
    using SafeERC20 for IERC20;
    using EnumerableSet for EnumerableSet.AddressSet;
    using EmissionsLib for EmissionsLib.BalanceData;
    using EmissionsLib for EmissionsLib.EmissionSchedule;
    using PriceLib for uint;
    using FeeLib for uint;

    uint internal constant WAD = 1e18;

    error WithdrawingLockedEmissions();

    // keccak256(abi.encode(uint(keccak256("openzeppelin.storage.InfraredCollateralVault")) - 1)) & ~bytes32(uint(0xff))
    bytes32 private constant InfraredCollateralVaultStorageLocation = 0xf6a35052099d23fafed8c58b549933969c057c5a9a13ac5133024adc8dd4f200;

    event Rebalance(address indexed sentCurrency, uint sent, uint received, uint sentValue, uint receivedValue);
    event PerformanceFee(address indexed token, uint amount);

    function _getInfraredCollVaultStorage() internal pure returns (IInfraredCollateralVault.InfraredCollVaultStorage storage store) {
        assembly {
            store.slot := InfraredCollateralVaultStorageLocation
        }
    }

    function __InfraredCollateralVault_init(IInfraredCollateralVault.InfraredInitParams calldata params) internal onlyInitializing {
        __InfraredCollateralVault_init_unchained(params);
    }

    function __InfraredCollateralVault_init_unchained(IInfraredCollateralVault.InfraredInitParams calldata params) internal onlyInitializing {
        IInfraredCollateralVault.InfraredCollVaultStorage storage $ = _getInfraredCollVaultStorage();

        if (params._iRedToken == address(0) ||  address(params._infraredVault) == address(0) || params._ibgtVault == address(0)) {
            revert("CollVault: 0 address");
        }

        IERC20 _asset = params._baseParams._asset;

        require(params._minPerformanceFee <= params._maxPerformanceFee && params._maxPerformanceFee <= BP, "CollVault: Incorrect min/max performance fee");
        require(params._performanceFee >= params._minPerformanceFee && params._performanceFee <= params._maxPerformanceFee, "CollVault: performance fee out of bounds");
        bool infraredWrapped = params._infraredWrapper != address(0);
        address stakingToken = params._infraredVault.stakingToken();
        require(infraredWrapped ? stakingToken == params._infraredWrapper : stakingToken == address(_asset), "CollVault: stakingToken mismatch");
        require(!infraredWrapped || IInfraredWrapper(params._infraredWrapper).infraredCollVault() == address(this), "CollVault: InfraredWrapper mismatch");

        $.minPerformanceFee = params._minPerformanceFee;
        $.maxPerformanceFee = params._maxPerformanceFee;
        $.performanceFee = params._performanceFee;

        $.iRedToken = params._iRedToken; // this set assumes that the iRedToken is a reward token in all InfraredVaults, which may not be the case
        $._infraredVault = params._infraredVault;
        $.ibgtVault = params._ibgtVault;
        $.infraredWrapper = IInfraredWrapper(params._infraredWrapper);

        __BaseCollateralVault_init(params._baseParams);

        $.ibgt = address(this) == params._ibgtVault ? address(_asset) : IIBGTVault(params._ibgtVault).asset();

        // so we don't have to approve() every time we stake into infrared
        IERC20(stakingToken).safeApprove(address(params._infraredVault), type(uint256).max);
    }

    // Compound iBGT rewards
    /// @dev Since we are not accepting donations, we won't `stake` ibgt.balanceOf(this)
    function _harvestRewards() internal override {
        if (block.timestamp == _getInfraredCollVaultStorage().lastUpdate) return;

        IInfraredVault iVault = infraredVault();
        address[] memory tokens = iVault.getAllRewardTokens();
        uint[] memory prevBalances = new uint[](tokens.length);

        for (uint i; i < tokens.length; i++) {
            prevBalances[i] = IERC20(tokens[i]).balanceOf(address(this));
        }

        // harvest rewards
        iVault.getReward();

        uint _performanceFee = getPerformanceFee();
        address _iRedToken = iRedToken();
        address _ibgt = ibgt();
        IIBGTVault _ibgtVault = IIBGTVault(ibgtVault());
        // re-stake iBGT, take performance fee and update accounting
        for (uint i; i < tokens.length; i++) {
            address _token = tokens[i];
            uint newBalance = IERC20(_token).balanceOf(address(this));

            uint rewards = newBalance - prevBalances[i];
            if (rewards == 0) continue; /// @dev Skip if no rewards, saves from iVault revert 'Cannot stake 0'

            (rewards, _token) = _autoCompoundHook(_token, _ibgt, _ibgtVault, rewards);

            // Meanwhile the token doesn't has an oracle mapped, it will be processed as a donation
            // This will avoid returns meanwhile a newly Infrared pushed reward token is not mapped
            if (_hasPriceFeed(_token) && _token != _iRedToken && !_isCollVault(_token)) {
                uint fee = rewards * _performanceFee / BP;
                uint netRewards = rewards - fee;

                if (_token == asset()) {
                    _stake(netRewards);
                }

                _increaseBalance(_token, netRewards);

                // First time the oracle happens to be mapped, we add the token to the rewardedTokens
                // If token has no oracle map this won't be called, hence not DOS the vault at `totalAssets`
                _addRewardedToken(_token); // won't add duplicates

                if (fee != 0) {
                    IERC20(_token).safeTransfer(getMetaBeraborrowCore().feeReceiver(), fee);

                    emit PerformanceFee(_token, fee);
                }
            }
        }
        _getInfraredCollVaultStorage().lastUpdate = uint96(block.timestamp);
    }

    /** @dev See {IERC4626-totalAssets}. */
    /// @notice Returns the total assets in the vault, denominated in the asset of the vault
    /// @dev Virtual accounting to avoid donations, asset valued denomination, returned in WAD
    /// @dev Not yet harvested rewards not yet added due to possible temporal overestimation due to rewards being donated through `getRewardForUser`
    function totalAssets() public view override virtual returns (uint amountInAsset) {
        // UsdValue is scaled to 1e18, since `getPrice` returns a WAD scaled price
        uint usdValue;
        address[] memory _rewardedTokens = rewardedTokens();
        uint rewardedTokensLength = _rewardedTokens.length;

        uint assetPrice = getPrice(asset());
        uint assetBalance = _isRewardedToken(asset()) ? 0 : getBalance(asset());

        for (uint i; i < rewardedTokensLength; i++) {
            usdValue += _convertToValue(_rewardedTokens[i]);
        }

        amountInAsset = usdValue.mulDiv(10 ** assetDecimals(), assetPrice) + assetBalance;
    }

    function _previewRedeem(uint shares) internal view override returns (uint, uint) {
        IInfraredCollateralVault.InfraredCollVaultStorage storage $ = _getInfraredCollVaultStorage();

        bool isInternalRedemption = address(this) == $.ibgtVault && getPriceFeed().isCollVault(msg.sender);
        uint shareFee = isInternalRedemption ? 0 : shares.feeOnRaw(getWithdrawFee());
        uint assets = ERC4626Upgradeable.previewRedeem(shares - shareFee);
        return (assets, shareFee);
    }

    /// @dev Token out or received currency will always be the asset of the vault
    function rebalance(IInfraredCollateralVault.RebalanceParams calldata p) external virtual onlyOwner {
        IInfraredCollateralVault.InfraredCollVaultStorage storage $ = _getInfraredCollVaultStorage();

        uint sentPrice = getPrice(p.sentCurrency);
        uint receivedPrice = getPrice(asset());
        uint8 sentDecimals = IAsset(p.sentCurrency).decimals();
        uint sentCurrencyBalance = IAsset(p.sentCurrency).balanceOf(address(this));
        uint receivedCurrencyBalance = IAsset(asset()).balanceOf(address(this));

        // Perform the swap using the swapper contract
        IERC20(p.sentCurrency).safeTransfer(p.swapper, p.sentAmount);
        IRebalancer(p.swapper).swap(
            p.sentCurrency,
            p.sentAmount,
            asset(),
            p.payload
        );

        uint received = IAsset(asset()).balanceOf(address(this)) - receivedCurrencyBalance;
        uint sent = sentCurrencyBalance - IAsset(p.sentCurrency).balanceOf(address(this));

        // if we were to rebalance locked emissions, a possible revert on subsequent `$.balanceOf` calls would occur
        if (sent > getBalance(p.sentCurrency)) revert WithdrawingLockedEmissions();

        uint receivedValue = received.convertToValue(receivedPrice, assetDecimals());
        uint sentValue = sent.convertToValue(sentPrice, sentDecimals);

        // if threshold isn't set, it will be 0, not tolerating any slippage
        require(receivedValue >= sentValue * (BP - $.threshold[p.sentCurrency]) / BP, "CollVault: received amount is below threshold");

        _decreaseBalance(p.sentCurrency, sent);
        _increaseBalance(asset(), received);

        _afterVaultRebalance(received);

        emit Rebalance(p.sentCurrency, sent, received, sentValue, receivedValue);
    }

    function setUnlockRatePerSecond(address token, uint64 _unlockRatePerSecond) external onlyOwner {
        _getBalanceData().setUnlockRatePerSecond(token, _unlockRatePerSecond);
    }

    /// @notice Creates a linear vesting for certain tokens donated to this vault
    /// @dev Make sure to call `setUnlockRatePerSecond` before calling this function for each token, default one is too low for this purpose
    function internalizeDonations(address[] memory tokens, uint128[] memory amounts) external virtual onlyOwner {
        uint tokensLength = tokens.length;

        require(tokensLength == amounts.length, "CollVault: tokens and amounts length mismatch");

        address _ibgt = ibgt();
        IIBGTVault _ibgtVault = IIBGTVault(ibgtVault());
        uint _performanceFee = getPerformanceFee();

        for (uint i; i < tokensLength; i++) {
            address token = tokens[i];
            uint amount = amounts[i];

            if (amount == 0) continue;

            // asset is staked in infraredVault, not in address(this)
            uint donatedAmount = token != asset()
                ? IERC20(token).balanceOf(address(this)) - getBalanceOfWithFutureEmissions(token)
                : IAsset(asset()).balanceOf(address(this));
            require(donatedAmount >= amount, "CollVault: insufficient balance");

            (amount, token) = _autoCompoundHook(token, _ibgt, _ibgtVault, amount);

            require(_isRewardedToken(token), "CollVault: token not rewarded");

            uint fee = amount * _performanceFee / BP;
            uint netAmounts = amount - fee;

            if (token == asset()) {
                _stake(netAmounts);
            }

            if (fee != 0) {
                IERC20(token).safeTransfer(getMetaBeraborrowCore().feeReceiver(), fee);
            }

            _getBalanceData().addEmissions(token, uint128(netAmounts));
        }
    }

    /// @dev Harvests rewards to don't have previously accrued but still not harvested rewards processed with the new fee
    function setPerformanceFee(uint16 _performanceFee) external virtual onlyOwner harvestRewards {
        IInfraredCollateralVault.InfraredCollVaultStorage storage $ = _getInfraredCollVaultStorage();

        require(_performanceFee >= $.minPerformanceFee && _performanceFee <= $.maxPerformanceFee, "CollVault: performance fee out of bounds");

        $.performanceFee = _performanceFee;
    }

    function setPairThreshold(address tokenIn, uint thresholdInBP) external virtual onlyOwner {
        IInfraredCollateralVault.InfraredCollVaultStorage storage $ = _getInfraredCollVaultStorage();

        require(thresholdInBP <= BP, "CollVault: threshold > BP");

        $.threshold[tokenIn] = thresholdInBP;
    }

    function setInfraredVault(IInfraredVault infrared) external onlyOwner {
        _getInfraredCollVaultStorage()._infraredVault = infrared;
    }

    function setIRED(address _iRedToken) external virtual onlyOwner {
        _getInfraredCollVaultStorage().iRedToken = _iRedToken;
    }

    function _increaseBalance(address token, uint amount) internal override {
        _getBalanceData().balance[token] += amount;
    }

    function _decreaseBalance(address token, uint amount) internal override {
        _getBalanceData().balance[token] -= amount;
    }

    /* Getters */

    /// @dev Doesn't include vesting amount, same as `getTokenVirtualBalance` in LSPGetters
    function getBalance(address token) public view override returns (uint) {
        return _getBalanceData().balanceOf(token);
    }

    /// @dev Includes vesting amount
    function getBalanceOfWithFutureEmissions(address token) public view virtual returns (uint) {
        return _getBalanceData().balance[token];
    }

    /// @dev Returns the locked emissions
    function getLockedEmissions(address token) public view returns (uint) {
        EmissionsLib.EmissionSchedule memory schedule = _getBalanceData().emissionSchedule[token];
        uint fullUnlockTimestamp = schedule.unlockTimestamp();

        return schedule.lockedEmissions(fullUnlockTimestamp);
    }

    function unlockRatePerSecond(address token) external view virtual returns (uint) {
        EmissionsLib.EmissionSchedule memory schedule = _getBalanceData().emissionSchedule[token];

        return schedule.unlockRatePerSecond();
    }

    function getFullProfitUnlockTimestamp(address token) external view returns (uint) {
        EmissionsLib.EmissionSchedule memory schedule = _getBalanceData().emissionSchedule[token];

        return schedule.unlockTimestamp();
    }

    function getPerformanceFee() public view virtual returns (uint16) {
        return _getInfraredCollVaultStorage().performanceFee;
    }

    /// @dev Returns tokens that has been rewarded at some point by the infrared vault
    function rewardedTokens() public view virtual returns (address[] memory) {
        return _getInfraredCollVaultStorage().rewardedTokens.values();
    }

    function _isRewardedToken(address token) internal view virtual returns (bool) {
        return _getInfraredCollVaultStorage().rewardedTokens.contains(token);
    }

    function _addRewardedToken(address token) internal virtual {
        IInfraredCollateralVault.InfraredCollVaultStorage storage $ = _getInfraredCollVaultStorage();
        $.rewardedTokens.add(token);
    }

    function iRedToken() public view virtual returns (address) {
        return _getInfraredCollVaultStorage().iRedToken;
    }

    function infraredVault() public view virtual returns (IInfraredVault) {
        return _getInfraredCollVaultStorage()._infraredVault;
    }

    function ibgt() public view virtual returns (address) {
        return _getInfraredCollVaultStorage().ibgt;
    }

    function ibgtVault() public view virtual returns (address) {
        return _getInfraredCollVaultStorage().ibgtVault;
    }

    function _stake(uint amount) internal override {
        IInfraredCollateralVault.InfraredCollVaultStorage storage $ = _getInfraredCollVaultStorage();
        IInfraredWrapper infraredWrapper = $.infraredWrapper;

        if (address(infraredWrapper) != address(0)) {
            IERC20(asset()).safeApprove(address(infraredWrapper), amount);
            infraredWrapper.depositFor(address(this), amount);
        }
        $._infraredVault.stake(amount);
    }

    function _unstake(uint amount) internal override {
        IInfraredCollateralVault.InfraredCollVaultStorage storage $ = _getInfraredCollVaultStorage();
        IInfraredWrapper infraredWrapper = $.infraredWrapper;

        $._infraredVault.withdraw(amount);

        if (address(infraredWrapper) != address(0)) {
            infraredWrapper.withdrawTo(address(this), amount);
        }
    }

    /// @dev Rewards the rest of the rewarded tokens (not the asset) to the receiver
    function _withdrawExtraRewardedTokens(
        address receiver,
        uint shares,
        uint _totalSupply
    ) internal override virtual {
        IInfraredCollateralVault.InfraredCollVaultStorage storage $ = _getInfraredCollVaultStorage();

        address[] memory tokens = rewardedTokens();
        uint tokensLength = tokens.length;
        address _ibgtVault = $.ibgtVault;

        for (uint i; i < tokensLength; i++) {
            address token = tokens[i];
            // if token is the asset, go next token since has already been transferred
            if (token == asset()) {
                continue;
            }

            uint amount = shares.mulDiv(getBalance(token), _totalSupply, Math.Rounding.Down);

            if (amount == 0) continue;
            _decreaseBalance(token, amount);

            if (token == _ibgtVault && _ibgtVault != address(this)) {
                IInfraredCollateralVault(token).redeem(amount, receiver, address(this));
            } else {
                IERC20(token).safeTransfer(receiver, amount);
            }
        }
    }

    function _hasPriceFeed(address token) internal view virtual returns (bool) {
        IPriceFeed priceFeed = getPriceFeed();

        (address oracle,,,,) = priceFeed.oracleRecords(token);

        IPriceFeed.FeedType memory feedInfo = priceFeed.feedType(token);

        return oracle != address(0) || feedInfo.isCollVault || feedInfo.spotOracle != address(0);
    }

    function _convertToValue(address token) public view virtual returns (uint) {
        uint currentBalance = getBalance(token);
        uint price = getPrice(token);
        uint8 _decimals = IAsset(token).decimals();
        return currentBalance.convertToValue(price, _decimals);
    }

    /**
     * @dev Hook that is called to check if the token is a collateral vault
     * @dev Prevents recursion DOS attacks by preventing the vault from being a reward token
     * Only collateral vault permitted is iBGTVault
     */
    function _isCollVault(address token) internal view virtual returns (bool) {
        IInfraredCollateralVault.InfraredCollVaultStorage storage $ = _getInfraredCollVaultStorage();

        // iBGTVault is the only collateral vault permitted, unless it is the current vault
        if (token == $.ibgtVault && $.ibgtVault != address(this)) {
            return false;
        }
        return getPriceFeed().isCollVault(token);
    }

    function _autoCompoundHook(address _token, address /*_ibgt*/, IIBGTVault /*_ibgtVault*/, uint _rewards) internal virtual returns (uint, address) {
        return (_rewards, _token);
    }

    /**
     * @dev Hook that is called after the vault has been rebalanced
     * Meant to be used by the child contract to stake the `asset()` in the infrared vault
     */
    function _afterVaultRebalance(uint amount) internal virtual {
        _stake(amount);
    }
}

// src/core/vaults/iBGTVault.sol

contract IBGTVault is InfraredCollateralVault { 
    function initialize(IInfraredCollateralVault.InfraredInitParams calldata baseParams) public initializer {
        __InfraredCollateralVault_init(baseParams);
    }
}
