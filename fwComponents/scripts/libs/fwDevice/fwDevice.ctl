#uses "fwConfigs/fwAlertConfig.ctl"
#uses "fwConfigs/fwAlertConfigDeprecated.ctl"
#uses "fwConfigs/fwArchive.ctl"
#uses "fwConfigs/fwDpFunction.ctl"
#uses "fwGeneral/fwExceptionHandling.ctl"
#uses "fwNode/fwNode.ctl"
#uses "fwConfigs/fwPeriphAddress.ctl"
#uses "fwConfigs/fwPeriphAddressS7.ctl"
#uses "fwConfigs/fwSmoothing.ctl"
#uses "fwConfigs/fwPeriphAddressSNMP.ctl"
#uses "fwGeneral/fwException.ctl"
#uses "fwGeneral/fwGeneral.ctl"
#uses "fwDevice/fwDeviceDeprecated.ctl"


/**@file

This library contains functions associated with all Framework devices. The functions
work at the device level, based on the information provided in the device/model definition.
There different groups of functions

	<li>Functions to create, delete, rename, move devices
	<li>Functions to handle the hardware and logical hierarchies
	<li>Functions to do operations like setting the addresses, the alerts or the archiving
	or a whole device, based on some defaults.

@par Creation Date
	11/07/02

@par Modification History

@par Constraints
	fwDevice_initialize has to be called once per manager before using any other function in the library

@author
	Manuel Gonzalez Berges (IT-CO)
*/

//@{

// +++++ CONFIGS +++++

// Supported configs indexes
const unsigned fwDevice_ALL					= 0;	///< all configs
const unsigned fwDevice_ADDRESS_INDEX		= 1;	///< address config
const unsigned fwDevice_ALERT_INDEX			= 2;	///< alert config
const unsigned fwDevice_ARCHIVE_INDEX		= 3;	///< archive config
const unsigned fwDevice_PVRANGE_INDEX		= 4;	///< pv_range config
const unsigned fwDevice_CONVERSION_INDEX	= 5;	///< conversion config
const unsigned fwDevice_SMOOTHING_INDEX		= 6;	///< smoothing config
const unsigned fwDevice_UNIT_INDEX			= 7;	///< unit (not a PVSS config, but we treat it as if it was)
const unsigned fwDevice_FORMAT_INDEX		= 8;	///< format (not a PVSS config, but we treat it as if it was)
const unsigned fwDevice_DPFUNCTION_INDEX	= 9;	///< dp_function config
const unsigned fwDevice_ORIGINAL_INDEX		= 10;

// limits for the above indexes
const unsigned MIN_CONFIG_INDEX = 1;
const unsigned MAX_CONFIG_INDEX = 9;

// CONFIG OBJECT
// Indexes for attributes
const int fwDevice_CONFIG_PROPERTY 	= 1;
const int fwDevice_CONFIG_DPE 		= 2;

const int fwDevice_CONFIG_MAX_INDEX = 2;

// DEVICE DEFINITION

global dyn_string fwDevice_CONFIG;
global dyn_string fwDevice_CONFIG_CAN_HAVE;

// Where to read attributes of config objects in the device definition
global dyn_dyn_string fwDevice_CONFIG_ATTRIBUTES_DEFINITION;

// Indicates empty entry in the device definition
string fwDevice_DEFINITION_EMPTY_ENTRY = "EMPTY";

// +++++ ADDRESS CONFIG +++++

// Indexes to access address objects
// Address object
global unsigned fwDevice_ADDRESS_TYPE;
global unsigned fwDevice_ADDRESS_DRIVER_NUMBER;
global unsigned fwDevice_ADDRESS_ROOT_NAME;

// OPC address object
global unsigned fwDevice_ADDRESS_OPC_SERVER_NAME;
global unsigned fwDevice_ADDRESS_OPC_GROUP_IN;
global unsigned fwDevice_ADDRESS_OPC_GROUP_OUT;

// OPC UA address object
global unsigned fwDevice_ADDRESS_OPCUA_SERVER_NAME;
global unsigned fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_IN;
global unsigned fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_OUT;
global unsigned fwDevice_ADDRESS_OPCUA_KIND;
global unsigned fwDevice_ADDRESS_OPCUA_VARIANT;

// S7 address object
global unsigned fwDevice_ADDRESS_S7_START		;
global unsigned fwDevice_ADDRESS_S7_SUBINDEX;
global unsigned fwDevice_ADDRESS_S7_INTERVAL;

// DIM address object
global unsigned fwDevice_ADDRESS_DIM_TIME_INTERVAL;
global unsigned fwDevice_ADDRESS_DIM_TIME_STAMP;

// Address types
const string fwDevice_ADDRESS_NONE		= "NO HARDWARE CONNECTION";
const string fwDevice_ADDRESS_DEFAULT	= "DEFAULT";
const string fwDevice_ADDRESS_OPC		= "OPC";
const string fwDevice_ADDRESS_DIM		= "DIM";
const string fwDevice_ADDRESS_MODBUS	= "MODBUS";
const string fwDevice_ADDRESS_DIP		= "DIP";
const string fwDevice_ADDRESS_S7		= "S7";
const string fwDevice_ADDRESS_SNMP		= "SNMP";
const string fwDevice_ADDRESS_OPCUA		= "OPCUA";

// Address direction types
global dyn_int fwDevice_ADDRESS_DIR_INPUT;
global dyn_int fwDevice_ADDRESS_DIR_OUTPUT;
global dyn_int fwDevice_ADDRESS_DIR_INPUT_OUTPUT;

// Address direction
const string fwDevice_ADDRESS_DPES_ALL 			= "ALL";
const string fwDevice_ADDRESS_DPES_INPUT 		= "INPUT";
const string fwDevice_ADDRESS_DPES_OUTPUT		= "OUTPUT";
const string fwDevice_ADDRESS_DPES_INPUT_OUTPUT = "INPUT/OUTPUT";

// Mapping of address mode to direction label
global dyn_string fwDevice_ADDRESS_MODE_TO_LABEL;

//
const unsigned fwDevice_ADDRESS_SUBSTITUTION_LEVELS = 4;

// Indexes to access OPC server object
const int fwDevice_OPC_SERVER_NAME				= 1;
const int fwDevice_OPC_SERVER_COMPUTER			= 2;
const int fwDevice_OPC_SERVER_PROGID			= 3;
const int fwDevice_OPC_SERVER_STATE_TIMER		= 4;
const int fwDevice_OPC_SERVER_RECONNECT_TIMER	= 5;

// Mapping of address mode to OPC group
global dyn_int fwDevice_ADDRESS_OPC_MODE_TO_GROUP_MAPPING;

// Constant for in/out mode. Can be removed when PVSS has one.
const int fwDevice_DPATTR_ADDR_MODE_INPUT_OUTPUT = 6;

// Constant for no config. DPCONFIG_NONE cannot be used in arrays because it is 0
const int fwDevice_DPCONFIG_NONE = 10;

// Commands
const string fwDevice_ADDRESS_SET 	= "ADDRESS SET";
const string fwDevice_ADDRESS_UNSET = "ADDRESS DEL";

// +++++ ALERT CONFIG +++++

// types of alert configuration
const string fwDevice_ALERT_NONE	= "NO ALARMS";
const string fwDevice_ALERT_DEFAULT	= "DEFAULT";

// Commands
const string fwDevice_ALERT_SET 	= "ALERT SET";
const string fwDevice_ALERT_UNSET 	= "ALERT UNSET";
const string fwDevice_ALERT_MASK 	= "ALERT MASK";
const string fwDevice_ALERT_UNMASK 	= "ALERT UNMASK";
const string fwDevice_ALERT_ACK 	= "ALERT ACK";
const string fwDevice_ALERT_SUMMARY_UNSET = "ALERT_SUMMARY_UNSET";

// +++++ ARCHIVE CONFIG +++++

// Commands
const string fwDevice_ARCHIVE_SET 	= "SET";
const string fwDevice_ARCHIVE_UNSET = "DEL";

// Default archive class
const string fwDevice_ARCHIVE_CLASS = "fwArchiver";

// +++++ DPFUNCTION CONFIG +++++

// Commands
const string fwDevice_DPFUNCTION_SET	= "SET";
const string fwDevice_DPFUNCTION_UNSET	= "UNSET";

// +++++ CONVERSION CONFIG +++++

// CONVERSION OBJECT
const int fwDevice_CONFIG_CONVERSION_TYPE = 1;


// +++++ DEVICE +++++

// Device object
const unsigned fwDevice_DP_NAME 	= 1;
const unsigned fwDevice_DP_TYPE 	= 2;
const unsigned fwDevice_COMMENT		= 3;
const unsigned fwDevice_MODEL		= 4;
const unsigned fwDevice_DP_ALIAS	= 5;
const unsigned fwDevice_ALIAS		= 6;
const unsigned fwDevice_TYPE		= 7;

const unsigned fwDevice_OBJECT_MAX_INDEX = 6;

// Device defaults
const unsigned fwDEVICE_DEFAULT_CONFIGS		= 1;
const unsigned fwDEVICE_DEFAULT_CHILDREN	= 2;

// Device panels
const unsigned fwDevice_PANEL_NAVIGATOR_HARDWARE 		= 1;
const unsigned fwDevice_PANEL_NAVIGATOR_LOGICAL			= 2;
const unsigned fwDevice_PANEL_EDITOR_HARDWARE			= 3;
const unsigned fwDevice_PANEL_EDITOR_LOGICAL			= 4;
const unsigned fwDevice_PANEL_EDITOR_EXPERT				= 5;
const unsigned fwDevice_PANEL_EDITOR_HARDWARE_ADD		= 6;
const unsigned fwDevice_PANEL_EDITOR_HARDWARE_REMOVE	= 7;

// Device default panels
const string fwDevice_PANEL_EDITOR_HARDWARE_ADD_DEFAULT = "fwDevice/fwDeviceCreate";


const string fwDevice_DEFINITION_SUFIX = "Info";

// storage for device definition related to dpes names, description, etc
const string 	fwDevice_ELEMENTS 				= ".properties.dpes";
const unsigned	fwDevice_ELEMENTS_INDEX			= 1;
const string 	fwDevice_PROPERTY_NAMES 		= ".properties.names";
const unsigned	fwDevice_PROPERTY_NAMES_INDEX 	= 2;
const string 	fwDevice_USER_DATA				= ".properties.userData";
const unsigned 	fwDevice_USER_DATA_INDEX		= 3;
const string 	fwDevice_DESCRIPTION			= ".properties.description";
const unsigned 	fwDevice_DESCRIPTION_INDEX		= 4;
const string 	fwDevice_DEFAULT_VALUES			= ".properties.defaultValues";
const unsigned 	fwDevice_DEFAULT_VALUES_INDEX	= 5;
const string 	fwDevice_ELEMENTS_TYPES			= ".properties.types";
const unsigned 	fwDevice_ELEMENTS_TYPES_INDEX	= 6;

// dpe types
const string fwDevice_DPE_TYPE_REFERENCE = "REFERENCE";
const string fwDevice_DPE_TYPE_INT		 = "INT";
const string fwDevice_DPE_TYPE_FLOAT	 = "FLOAT";
const string fwDevice_DPE_TYPE_BOOL		 = "BOOL";
const string fwDevice_DPE_TYPE_STRING	 = "STRING";

// +++++ HIERARCHY +++++

// Hierarchy related constants
const string fwDevice_HIERARCHY_SEPARATOR	= "/";
const string fwDevice_HIERARCHY_LOGICAL_CUT	= "!";
const int fwDevice_HIERARCHY_DP_NAME			= 1;
const int fwDevice_HIERARCHY_POSITION_STRING	= 2;
const int fwDevice_HIERARCHY_POSITION			= 3;

// Tree types
const string fwDevice_HARDWARE 			= "HARDWARE";
const string fwDevice_HARDWARE_SELECT 	= "HARDWARE SELECT";
const string fwDevice_LOGICAL 			= "LOGICAL";
const string fwDevice_LOGICAL_CLIPBOARD	= "LOGICAL CLIPBOARD";
const string fwDevice_FSM_EDITOR = "FSM_EDITOR";
const string fwDevice_FSM_NAVIGATOR = "FSM_NAVIGATOR";

// +++++ MODEL +++++

const int fwDevice_MODEL_SLOTS 					= 1;
const int fwDevice_MODEL_SYMBOLS				= 2;
const int fwDevice_MODEL_UNITS					= 3;
const int fwDevice_MODEL_LIMITS					= 4;
const int fwDevice_MODEL_WIDTH					= 5;
const int fwDevice_MODEL_CHILDREN_DP_TYPES		= 6;
const int fwDevice_MODEL_NAME_ROOT				= 7;
const int fwDevice_MODEL_NAME_DIGITS			= 8;
const int fwDevice_MODEL_STARTING_NUMBER		= 9;

global mapping fwDevice_modelDpCache;


// +++++ OTHER +++++
const int fwDevice_DEFAULT_SLOTS_NUMBER = 20;


// This is used to be able to have mappings as optional parameters
global mapping fwDevice_emptyMap;


//@}

//@{
/** Initializes constants required for the fwDevice.ctl library.
This function has to be called prior to any other function in
the library. It is required once per manager.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL
*/
fwDevice_initialize()
{
	dyn_string exceptionInfo;

	// Initialization to make constant coherent with fwPeriphAddress.pnl
	// Common address object
	fwDevice_ADDRESS_TYPE 			= fwPeriphAddress_TYPE;
	fwDevice_ADDRESS_DRIVER_NUMBER 	= fwPeriphAddress_DRIVER_NUMBER;
	fwDevice_ADDRESS_ROOT_NAME		= fwPeriphAddress_ROOT_NAME;

//	DebugN("fwDevice_ADDRESS_TYPE ", fwDevice_ADDRESS_TYPE, fwPeriphAddress_TYPE);

	// OPC address object
	fwDevice_ADDRESS_OPC_SERVER_NAME = fwPeriphAddress_OPC_SERVER_NAME;
	fwDevice_ADDRESS_OPC_GROUP_IN 	= fwPeriphAddress_OPC_GROUP_IN;
	fwDevice_ADDRESS_OPC_GROUP_OUT 	= fwPeriphAddress_OPC_GROUP_OUT;


	// OPC UA address object
	// TODO: need a separated group for IN and OUT
	fwDevice_ADDRESS_OPCUA_SERVER_NAME = fwPeriphAddress_OPCUA_SERVER_NAME;
	fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_IN 	= fwPeriphAddress_OPCUA_SUBSCRIPTION;
	fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_OUT = fwPeriphAddress_OPCUA_SUBSCRIPTION;
	fwDevice_ADDRESS_OPCUA_KIND = fwPeriphAddress_OPCUA_KIND;
	fwDevice_ADDRESS_OPCUA_VARIANT = fwPeriphAddress_OPCUA_VARIANT;

	 //  S7 Address  object
 	fwDevice_ADDRESS_S7_START	 = fwPeriphAddress_S7_START;
 	fwDevice_ADDRESS_S7_SUBINDEX = fwPeriphAddress_S7_SUBINDEX;
 	fwDevice_ADDRESS_S7_INTERVAL = fwPeriphAddress_S7_INTERVAL;

	// DIM address object
	fwDevice_ADDRESS_DIM_TIME_INTERVAL 	= fwPeriphAddress_DIM_TIMEOUT;
	fwDevice_ADDRESS_DIM_TIME_STAMP		= fwPeriphAddress_DIM_FLAG;

	// The initialization of this variables has to be here because
	// variables declared outside cannot be initialized with a
	// function (makeDynString).
	fwDevice_CONFIG = makeDynString(	"ADDRESS",
										"ALERT",
										"ARCHIVE",
										"PVRANGE",
										"CONVERSION",
										"SMOOTHING",
										"UNIT",
										"FORMAT",
										"DPFUNCTION");
	fwDevice_CONFIG_CAN_HAVE = makeDynString(	".configuration.address.canHave",
												".configuration.alert.canHave",
												".configuration.archive.canHave",
												".configuration.pvRange.canHave",
												".configuration.conversion.canHave",
												".configuration.smoothing.canHave",
												".configuration.unit.canHave",
												".configuration.format.canHave",
												".configuration.dpFunction.canHave");

	fwDevice_ADDRESS_DIR_INPUT = makeDynInt(
     DPATTR_ADDR_MODE_INPUT_SPONT,	// input for spontaneous data
					DPATTR_ADDR_MODE_INPUT_SQUERY,	// input for single queries
					DPATTR_ADDR_MODE_INPUT_POLL,	// input for polling
					fwDevice_DPATTR_ADDR_MODE_INPUT_OUTPUT  // i/o address as input for the moment
 );

	fwDevice_ADDRESS_DIR_OUTPUT = makeDynInt(
     DPATTR_ADDR_MODE_OUTPUT,			// output with group connected
					DPATTR_ADDR_MODE_OUTPUT_SINGLE // output for single queries
 );

	fwDevice_ADDRESS_DIR_INPUT_OUTPUT = makeDynInt(
     fwDevice_DPATTR_ADDR_MODE_INPUT_OUTPUT,
     DPATTR_ADDR_MODE_IO_SPONT,
     DPATTR_ADDR_MODE_IO_POLL,
     DPATTR_ADDR_MODE_IO_SQUERY
 );

	// mapping of modes to OPC group
	fwDevice_ADDRESS_OPC_MODE_TO_GROUP_MAPPING[DPATTR_ADDR_MODE_INPUT_SPONT]	= fwDevice_ADDRESS_OPC_GROUP_IN;
	fwDevice_ADDRESS_OPC_MODE_TO_GROUP_MAPPING[DPATTR_ADDR_MODE_INPUT_SQUERY]	= fwDevice_ADDRESS_OPC_GROUP_IN;
	fwDevice_ADDRESS_OPC_MODE_TO_GROUP_MAPPING[DPATTR_ADDR_MODE_INPUT_POLL]		= fwDevice_ADDRESS_OPC_GROUP_IN;
	fwDevice_ADDRESS_OPC_MODE_TO_GROUP_MAPPING[DPATTR_ADDR_MODE_OUTPUT]			= fwDevice_ADDRESS_OPC_GROUP_OUT;
	fwDevice_ADDRESS_OPC_MODE_TO_GROUP_MAPPING[DPATTR_ADDR_MODE_OUTPUT_SINGLE]	= fwDevice_ADDRESS_OPC_GROUP_OUT;
	fwDevice_ADDRESS_OPC_MODE_TO_GROUP_MAPPING[fwDevice_DPATTR_ADDR_MODE_INPUT_OUTPUT]	= fwDevice_ADDRESS_OPC_GROUP_IN; // i/o address as input for the moment


	// Mapping of address mode to direction label
	fwDevice_ADDRESS_MODE_TO_LABEL[fwDevice_DPCONFIG_NONE]					= "";
	fwDevice_ADDRESS_MODE_TO_LABEL[DPATTR_ADDR_MODE_INPUT_SPONT]	= fwDevice_ADDRESS_DPES_INPUT;
	fwDevice_ADDRESS_MODE_TO_LABEL[DPATTR_ADDR_MODE_INPUT_SQUERY]	= fwDevice_ADDRESS_DPES_INPUT;
	fwDevice_ADDRESS_MODE_TO_LABEL[DPATTR_ADDR_MODE_INPUT_POLL]		= fwDevice_ADDRESS_DPES_INPUT;
	fwDevice_ADDRESS_MODE_TO_LABEL[DPATTR_ADDR_MODE_OUTPUT]			= fwDevice_ADDRESS_DPES_OUTPUT;
	fwDevice_ADDRESS_MODE_TO_LABEL[DPATTR_ADDR_MODE_OUTPUT_SINGLE]	= fwDevice_ADDRESS_DPES_OUTPUT;
	fwDevice_ADDRESS_MODE_TO_LABEL[fwDevice_DPATTR_ADDR_MODE_INPUT_OUTPUT]	= fwDevice_ADDRESS_DPES_INPUT_OUTPUT;

	// Where to read attributes of objects associated with the different configs
	// afterwards to put them in the object, the index has to be with the
	// offset of the basic config object (fwDevice_CONFIG_MAX_INDEX)

	fwDevice_CONFIG_ATTRIBUTES_DEFINITION[fwDevice_ADDRESS_INDEX]	=
		makeDynString(	".configuration.address.direction");

	fwDevice_CONFIG_ATTRIBUTES_DEFINITION[fwDevice_ALERT_INDEX]		=
		makeDynString();

	fwDevice_CONFIG_ATTRIBUTES_DEFINITION[fwDevice_ARCHIVE_INDEX]	=
		makeDynString();

	fwDevice_CONFIG_ATTRIBUTES_DEFINITION[fwDevice_PVRANGE_INDEX]	=
		makeDynString();

	fwDevice_CONFIG_ATTRIBUTES_DEFINITION[fwDevice_CONVERSION_INDEX] =
		makeDynString(".configuration.conversion.type");

	fwDevice_CONFIG_ATTRIBUTES_DEFINITION[fwDevice_SMOOTHING_INDEX]	=
		makeDynString();

	fwDevice_CONFIG_ATTRIBUTES_DEFINITION[fwDevice_UNIT_INDEX] =
		makeDynString();

}


/** Checks whether a device type can have default configuration

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION,	CTRL

@param device			device object (only the dp type/model or dp name is required)
@param canHaveDefaults	whether the device can have default for:
							<li>configs (index fwDEVICE_DEFAULT_CONFIGS)
							<li>automatic children generation (index fwDEVICE_DEFAULT_CHILDREN)
@param exceptionInfo 	details of any exceptions are returned here
*/
fwDevice_canHaveDefaults(dyn_string device, dyn_bool &canHaveDefaults, dyn_string &exceptionInfo)
{
	string definitionDp;
	dyn_string modelDp;

	fwDevice_getDefinitionDp(device, definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(definitionDp + ".configuration.canHaveDefaults", canHaveDefaults[fwDEVICE_DEFAULT_CONFIGS]);

	fwDevice_getModelDp(device, modelDp, exceptionInfo);
	if(dynlen(modelDp) == 3)
	{
		dpGet(modelDp[1] + ".general.canHaveAutomaticChildrenGeneration", canHaveDefaults[fwDEVICE_DEFAULT_CHILDREN]);
	}
	else
	{
		canHaveDefaults[fwDEVICE_DEFAULT_CHILDREN] = false;
	}
}

/** Checks whether an address configuration is correct and could
be applied

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device 				device object
@param addressParameters	structure with the address configuration
@param isOk					indicates whether the address specified in addressParameters can be used
@param exceptionInfo		details of any exceptions are returned here, indicating if the address is correct
*/
fwDevice_checkAddress(dyn_string device, dyn_string addressParameters, bool &isOk, dyn_string &exceptionInfo)
{
	bool isRunning;
	int driverNumber;

	//DebugN("fwDevice_checkAddress() " + device);
	if(addressParameters[fwDevice_ADDRESS_TYPE] == fwDevice_ADDRESS_DEFAULT)
	{
		fwDevice_getAddressDefaultParams(device[fwDevice_DP_TYPE], addressParameters, exceptionInfo, device[fwDevice_MODEL]);
	}

	//DebugN("fwDevice_checkAddress() " + addressParameters);

	switch(addressParameters[fwDevice_ADDRESS_TYPE])
	{
		case fwDevice_ADDRESS_NONE:
		case fwDevice_ADDRESS_DIM:
		    if (dynlen(dpTypes("_FwDimConfig"))<1) { // checking of type is much faster than check of component installation - no dpGet there
			fwException_raise(exceptionInfo,"ERROR","fwDevice_checkAddress(): DIM address requested but fwDIM component not installed","");
			isOk=false;
			return;
		    }
		    isOk=true;
		    return;
		case fwDevice_ADDRESS_DIP:
		    if (dynlen(dpTypes("_FwDipConfig"))<1) { // checking of type is much faster than check of component installation - no dpGet there
			fwException_raise(exceptionInfo,"ERROR","fwDevice_checkAddress(): DIP address requested but fwDIP component not installed","");
			isOk=false;
			return;
		    }
		    isOk=true;
		    return;
		case "":
		{
			isOk=true;
			return;
		}
		default:
			break;
	}

	driverNumber = (int) addressParameters[fwDevice_ADDRESS_DRIVER_NUMBER];
	fwPeriphAddress_checkIsDriverRunning(driverNumber, isRunning, exceptionInfo);

	isOk = isRunning;
	//DebugN(isOk, isRunning);
}



/** Copies a device from source to destination. The copy includes all configs.
The new address configs, by default will be in driver number 1. One has to be
careful because PVSS doesn't allow duplicate output addresses, so if the driver
number is the same as the one used in the source device, then there will be errors.
There can also be problems if one copies the same device twice and one doesn't
update the address configs between both copies. If the device supports default
address config, it is recommended to apply it between copies.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param sourceDeviceDpName		device object
@param destinationDeviceDpName	parent device object
@param exceptionInfo			details of any exceptions are returned here
@param driverNumber				driver number for the destination device address configs
*/
fwDevice_copy(string sourceDeviceDpName, string destinationDeviceDpName, dyn_string &exceptionInfo, int driverNumber = 1)
{
	int error;
	dyn_errClass lastError;

//	fwGeneral_getNameWithoutSN(sourceDeviceDpName, sourceDeviceDpName, exceptionInfo);
	fwGeneral_getNameWithoutSN(destinationDeviceDpName, destinationDeviceDpName, exceptionInfo);

//	DebugN("fwDevice_copy(): copying " + sourceDeviceDpName + " into " + destinationDeviceDpName);

	// clear PVSS buffer
	dpCopyBufferClear();

	// copy source device to destination with all configs except original
	dpCopy(sourceDeviceDpName, destinationDeviceDpName, error, driverNumber);
	if(error < 0)
	{
		lastError = getLastError();
		//DebugN("fwDevice_copy: ", lastError);
		fwException_raise(	exceptionInfo, "ERROR",
							"fwDevice_copy(): There were problems copying " + sourceDeviceDpName + " to " + destinationDeviceDpName,
							error);
	}
//	DebugN("Copying (dpCopy)" + sourceDevice + " into " + destinationDevice + ". Error code: " + error);

	// copy original values
	dpCopyOriginal(sourceDeviceDpName, destinationDeviceDpName, error);
	if(error < 0)
		fwException_raise(	exceptionInfo, "ERROR",
							"fwDevice_copy(): There were problems copying the original values of " + sourceDeviceDpName + " to " + destinationDeviceDpName,
							error);
//	DebugN("Copying (dpCopyOriginal)" + sourceDevice + " into " + destinationDevice + ". Error code: " + error);
}


/** Copies a device and all of its children from source to destination. The
copy includes all configs. The new address configs, by default will be in driver
number 1. One has to be careful because PVSS doesn't allow duplicate output addresses,
so if the driver number is the same as the one used in the source device, then there
will be errors. There can also be problems if one copies the same device twice and
one doesn't update the address configs between both copies. If the device supports
default address config, it is recommended to apply it between copies.

	The copy is carried from bottom to top, to avoid the problem of references to
non existing devices.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param sourceDeviceDpName		device object:
@param destinationDeviceDpName	parent device object
@param exceptionInfo			details of any exceptions are returned here
@param driverNumber				driver number for the destination device address configs
*/
fwDevice_copyRecursively(string sourceDeviceDpName, string destinationDeviceDpName, dyn_string &exceptionInfo, int driverNumber = 1)
{
	int i;
	string deviceName;
	dyn_string children;

	// iterate through the children of the device
	fwDevice_getChildren(sourceDeviceDpName, fwDevice_HARDWARE, children, exceptionInfo);
	for(i = 1; i <= dynlen(children); i++)
	{
		fwDevice_getName(children[i], deviceName, exceptionInfo);
		fwDevice_copyRecursively(children[i], destinationDeviceDpName + fwDevice_HIERARCHY_SEPARATOR + deviceName, exceptionInfo, driverNumber);
	}

	fwDevice_copy(sourceDeviceDpName, destinationDeviceDpName, exceptionInfo, driverNumber);
}


/** Creates a device inside PVSS with the characteristics specified in the
device object and having as parent the parent device.
It returns the same device object that was passed as a parameter, with device[fwDevice DP NAME] set to the full dp name.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device			device object
@param parentDevice		parent device object
@param exceptionInfo	details of any exceptions are returned here
@param setDefaults [default true] set defaults when device is created
*/
dyn_string fwDevice_create(dyn_string device, dyn_string parentDevice, dyn_string &exceptionInfo, mapping replacements = fwDevice_emptyMap, bool setDefaults = true)
{

	//DebugN("fwDevice_create()" + device);

	if(device[fwDevice_DP_NAME] == "")
	{
		fwException_raise(	exceptionInfo,
							"ERROR",
							"fwDevice_create: the device name cannot be empty.",
							"");
		return device;
	}

	if(parentDevice[fwDevice_DP_NAME] != "")
	{
		if (!dpExists(parentDevice[fwDevice_DP_NAME]))
		{
			fwException_raise(	exceptionInfo,
								"ERROR",
								"fwDevice_create: the parent (" + parentDevice[fwDevice_DP_NAME] + ")of the device you are trying to create ("
								+ device[fwDevice_DP_NAME] + " does not exist.",
								"");
			return device;
		}
		// make device dp name
		device[fwDevice_DP_NAME] = 	dpSubStr(parentDevice[fwDevice_DP_NAME], DPSUB_DP) +
									fwDevice_HIERARCHY_SEPARATOR + device[fwDevice_DP_NAME];
	}

	if (dpExists(device[fwDevice_DP_NAME]))
	{
		fwException_raise(	exceptionInfo,
							"ERROR",
							"fwDevice_create: device data point " + device[fwDevice_DP_NAME] + " (dpt "
							+ dpTypeName(device[fwDevice_DP_NAME])+ ") already exists.",
							"");
		return device;
	}

	//DebugN("Creating DP " + device);
	// create datapoint
	dpCreate(device[fwDevice_DP_NAME], device[fwDevice_DP_TYPE]);
	device[fwDevice_DP_NAME] = getSystemName() + device[fwDevice_DP_NAME];

	// check dp was created successfully
	if(!dpExists(device[fwDevice_DP_NAME]))
	{
		fwException_raise(	exceptionInfo,
							"ERROR",
							"fwDevice_create():  The device " + device[fwDevice_DP_NAME] + " was not successfully created.",
							"");
		return device;
	}

	if(dynlen(device) >= fwDevice_MODEL)
	{
		if(device[fwDevice_MODEL] != "")
		{
			dyn_string modelDp;
			fwDevice_setModel(device[fwDevice_DP_NAME], device[fwDevice_MODEL], exceptionInfo);
			fwDevice_getModelDp(device, modelDp, exceptionInfo);

			// apply units settings

			// apply limits settings

		/*// e.g. _FwCaenBoardModelA3031Definition
		string dpModelDefinition = device[fwDevice_DP_TYPE] + "Model" + device[fwDevice_MODEL] + "Definition";
		string fwDevice_PARENT_MODEL_REPLACE_STR = "%model2%";

		dyn_string settings;

		// apply units settings
		dpGet(dpModelDefinition + ".units", ds);
		for(i = 1; i <= dynlen(ds); i++)
		{
			settings = strsplit(ds, "=,");
			dpSetUnit(ds[1], ds[2]);
		}

		// apply limits settings
		dpGet(dpModelDefinition + ".limits", ds);
		for(i = 1; i <= dynlen(ds); i++)
		{
			settings = strsplit(ds, "=");
			dpSetUnit(ds[1], ds[2]);
		}*/
		}
	}

	// set the comment
	if(dynlen(device) >= fwDevice_COMMENT)
		dpSetComment(device[fwDevice_DP_NAME] + ".", device[fwDevice_COMMENT]);

	// set the default values
	if(setDefaults)
		fwDevice_setDefaultValues(device[fwDevice_DP_NAME], exceptionInfo, replacements);

 return device;
}

/** Creates a data structure with all the parameters necessary
to set up a DIM address

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param driverNumber			driver number
@param rootName				root name to build the DIM item name
@param timeInterval			The time interval in seconds for periodic reception - 0 for on change (default)
@param timeStamp			quality and time-stamp flag - 1 for quality and time-stamp (default)
@param addressParameters	structure with the DIM parameters
@param exceptionInfo		details of any exceptions are returned here
*/
fwDevice_createDIMAddress(	int driverNumber, string rootName, int timeInterval,
							bool timeStamp, dyn_string &addressParameters, dyn_string &exceptionInfo)
{
	addressParameters[fwDevice_ADDRESS_TYPE]				= "DIM";
	addressParameters[fwDevice_ADDRESS_DRIVER_NUMBER]		= driverNumber;
	addressParameters[fwDevice_ADDRESS_ROOT_NAME] 			= rootName;
	addressParameters[fwDevice_ADDRESS_DIM_TIME_INTERVAL]	= timeInterval;
	addressParameters[fwDevice_ADDRESS_DIM_TIME_STAMP]		= timeStamp;
}



/** Creates a data structure with all the parameters necessary
to set up an OPC address

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param driverNumber			driver number
@param rootName				root name to build the OPC item name
@param opcServerName		name given to the OPC server inside PVSS
@param inOPCGroup			one of the PVSS OPC groups used to read data
@param outOPCGroup			one of the PVSS OPC groups used to write data
@param addressParameters	structure with the OPC parameters
@param exceptionInfo		details of any exceptions are returned here
*/
fwDevice_createOPCAddress(	int driverNumber, string rootName, string opcServerName, string inOPCGroup,
							string outOPCGroup, dyn_string &addressParameters, dyn_string &exceptionInfo)
{
//	DebugN("fwDevice_createOPCAddress fwDevice_ADDRESS_TYPE",fwDevice_ADDRESS_TYPE);
	addressParameters[fwDevice_ADDRESS_TYPE]			= "OPC";
	addressParameters[fwDevice_ADDRESS_DRIVER_NUMBER]	= driverNumber;
	addressParameters[fwDevice_ADDRESS_ROOT_NAME]		= rootName;
	addressParameters[fwDevice_ADDRESS_OPC_SERVER_NAME]	= opcServerName;
	addressParameters[fwDevice_ADDRESS_OPC_GROUP_IN]	= inOPCGroup;
	addressParameters[fwDevice_ADDRESS_OPC_GROUP_OUT]	= outOPCGroup;
}


/** Creates a data structure with all the parameters necessary
to set up an OPC UA address

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param driverNumber			driver number
@param rootName				root name to build the OPC item name
@param opcServerName		name given to the OPC server inside PVSS
@param inSubscription			one of the PVSS OPC groups used to read data
@param outSubscription		one of the PVSS OPC groups used to write data
@param addressParameters	structure with the OPC parameters
@param exceptionInfo		details of any exceptions are returned here
*/
fwDevice_createOPCUAAddress(	int driverNumber, string rootName, string opcServerName, string inSubscription,
							string outSubscription, dyn_string &addressParameters, dyn_string &exceptionInfo)
{
	//DebugN("fwDevice_createOPCAddress fwDevice_ADDRESS_TYPE",fwDevice_ADDRESS_TYPE);

	addressParameters[fwDevice_ADDRESS_TYPE]			= "OPCUA";
	addressParameters[fwDevice_ADDRESS_DRIVER_NUMBER]	= driverNumber;
	addressParameters[fwDevice_ADDRESS_ROOT_NAME]		= rootName;
	addressParameters[fwDevice_ADDRESS_OPCUA_SERVER_NAME]	= opcServerName;
	addressParameters[fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_IN]	= inSubscription;
	addressParameters[fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_OUT]	= outSubscription;
	DebugFTN("FW_INFO", "fwDevice_createOPCUAAddress(): addressParameters: ", addressParameters, "opcServerName: ", opcServerName,
	 			"| driverNumber: ", driverNumber,  "| outSubscription: ", outSubscription,
	 			"| inSubscription: ", inSubscription, "| rootName: ", rootName);
}


/** Creates a data structure with all the parameters necessary
to set up an S7 address

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param driverNumber			driver number
*/
fwDevice_createS7Address(	int driverNumber, int s7Start, int s7SubIndex, int s7Interval, dyn_string &addressParameters, dyn_string &exceptionInfo)
{
	addressParameters[fwDevice_ADDRESS_TYPE]			= "S7";
	addressParameters[fwDevice_ADDRESS_DRIVER_NUMBER]	= driverNumber;
	addressParameters[fwDevice_ADDRESS_S7_START]		= s7Start;
	addressParameters[fwDevice_ADDRESS_S7_SUBINDEX]	= s7SubIndex;
	addressParameters[fwDevice_ADDRESS_S7_INTERVAL]	= s7Interval;

}

/**Deletes a device and all of its children in the hardware hierarchy from the system

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName		the data point name of device to be deleted, the system name is included
@param exceptionInfo	details of any exceptions are returned here
*/
fwDevice_delete(string deviceDpName, dyn_string &exceptionInfo)
{
	int i;
	dyn_string children;

	//DebugN("Deleting " + deviceDpName);
	// check dp name not empty
	if(deviceDpName == "")
	{
		fwException_raise(	exceptionInfo,
							"ERROR",
							"fwDevice_delete(): The data point name must not be empty",
							"");
		return;
	}

	// check whether the system name was given
	if(strpos(deviceDpName, ":") < 0)
	{
		fwException_raise(exceptionInfo,
						"INFO",
						"fwDevice_delete(): The system name must be given",
						"");
		return;
	}

	// check that the dp does exist
	if(!dpExists(deviceDpName))
	{
		fwException_raise(exceptionInfo,
						"INFO",
						"fwDevice_delete(): The data point\n" + deviceDpName + "\n does not\nexist",
						"");
		return;
	}

	// remove all references to the device
	// only removal from all alert summaries is needed for redesign

	// delete all chidren
	fwDevice_getChildren(deviceDpName, fwDevice_HARDWARE, children, exceptionInfo);
	for(i = 1; i <= dynlen(children); i++)
	{
		fwDevice_delete(children[i], exceptionInfo);
	}

	// remove from hardware and logical parent summaries
	fwDevice_setAlert(deviceDpName, fwDevice_ALERT_SUMMARY_UNSET, exceptionInfo);
	// delete the dp
	dpDelete(deviceDpName);

	// check that the dp was deleted successfully
	if(dpExists(deviceDpName))
	{
		fwException_raise(exceptionInfo,
						"INFO",
						"fwDevice_delete(): The data point \n" + deviceDpName + "\n was not\nsuccessfully deleted",
						"");
		return;
	}
}

/**Renames a device and all of its children in the logical view.
Can be used to delete from the logical view by entering "" as the
new parent alias.

@par Constraints
	Works only for the local system

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device				device object, only the data for the device dp alias needs to be present
@param newParentDpAlias		dp alias set for the parent. It will be used as root. "" to cut to clipboard
@param exceptionInfo		details of any exceptions are returned here
*/
fwDevice_deleteLogical(dyn_string device, string newParentDpAlias, dyn_string &exceptionInfo)
{
	int result;
	string newDpAlias, systemName;
	dyn_string children;

	//DebugN("fwDevice_deleteLogical(): device " + device[fwDevice_DP_ALIAS] + " newParentDpAlias " + newParentDpAlias);

	// check dp alias not empty
	if(device[fwDevice_DP_ALIAS] == "")
	{
		fwException_raise(	exceptionInfo,
							"ERROR",
							"fwDevice_deleteLogical(): The device dp alias must not be empty",
							"");
		return;
	}

	// dpAliasToName doesn't work in a distributed system, so the function only works locally
	fwGeneral_getSystemName(device[fwDevice_DP_ALIAS], systemName, exceptionInfo);
	if(systemName != getSystemName() && systemName != "")
	{
		fwException_raise(	exceptionInfo,
							"ERROR",
							"fwDevice_deleteLogical(): device with alias " + device[fwDevice_DP_ALIAS]+ " is not in the local system.",
							"");
		return;
	}
	fwGeneral_getNameWithoutSN(device[fwDevice_DP_ALIAS], device[fwDevice_DP_ALIAS], exceptionInfo);

	// check that the dp does exist
	device[fwDevice_DP_NAME] = dpAliasToName(device[fwDevice_DP_ALIAS]);
	device[fwDevice_DP_NAME] = strrtrim(device[fwDevice_DP_NAME], ".");
	if(!dpExists(device[fwDevice_DP_NAME]))
	{
		fwException_raise(exceptionInfo,
						"INFO",
						"fwDevice_deleteLogical(): The data point alias" + device[fwDevice_DP_ALIAS] + " does not exist.",
						"");
		return;
	}

	// remove all references to the device
	// only removal from all alert summaries is needed for redesign [TO BE DONE]

	// APPLY TO CHILDREN ALSO

	fwDevice_getChildren(device[fwDevice_DP_ALIAS], fwDevice_LOGICAL, children, exceptionInfo);
	//DebugN("Children of " + device[fwDevice_DP_ALIAS] + " are " + children);
	fwDevice_getName(device[fwDevice_DP_ALIAS], device[fwDevice_ALIAS], exceptionInfo);
	// DebugN("fwDevice_deleteLogical(): device " + device);

	// calculate new alias for dp
	if(newParentDpAlias == "")
	{
		newDpAlias = fwDevice_HIERARCHY_LOGICAL_CUT + device[fwDevice_ALIAS];
	}
	else
	{
		newDpAlias = newParentDpAlias + fwDevice_HIERARCHY_SEPARATOR + device[fwDevice_ALIAS];
	}

	// iterate through the children
	for(int i = 1; i <= dynlen(children); i++)
	{
		fwDevice_deleteLogical(makeDynString("", "", "", "", children[i]), newDpAlias, exceptionInfo);
	}

	// set the alias to move to the clipboard
	result = dpSetAlias(device[fwDevice_DP_NAME] + ".", newDpAlias);
	//DebugN("fwDevice_deleteLogical: Set alias of " + device[fwDevice_DP_NAME] + " to " + newDpAlias + " with result " + result);

	// if alias was set properly then check if it was the root
	// of the deleted tree to set it as root in the clipboard
	if(result == 0)
	{
		if(newParentDpAlias == "")
		{
			// only nodes can be kept as root entries
			fwNode_setType(device[fwDevice_DP_NAME], fwNode_TYPE_LOGICAL_DELETED_ROOT, exceptionInfo);
		}
	}
	else
	{
		fwException_raise(exceptionInfo,
						"ERROR",
						"fwDevice_deleteLogical(): could not set alias of " + device[fwDevice_DP_NAME] + " to " + newDpAlias,
						"");
		return;
	}
}


/** This function will display the first of the configuration panels
defined for the specified device.

@par Constraints
	The panel to be displayed has to accept $sDpName and $bHierarchyBrowser
	as dollar parameters

@par Usage
	Public

@par PVSS managers
	VISION

@param deviceDpName		name of the device to be passed as parameter to the panel
@param exceptionInfo	details of any exceptions
*/
fwDevice_displayConfigurationPanel(string deviceDpName, dyn_string &exceptionInfo)
{
	string deviceModel;
	dyn_string panels;

	fwDevice_getModel(makeDynString(deviceDpName), deviceModel, exceptionInfo);

	if (!dynlen(exceptionInfo)) fwDevice_getDefaultConfigurationPanels(dpTypeName(deviceDpName), panels, exceptionInfo, deviceModel);

	if (dynlen(exceptionInfo)) {
	    // add some more information to the exception
	    fwException_raise(exceptionInfo,"ERROR","Could not display configuration panel for device "+deviceDpName,"");
	    // and display it
	    fwExceptionHandling_display(exceptionInfo);
	    return;
	}


  string sMyModuleName;
  sMyModuleName = myModuleName();

  if( !isModuleOpen(sMyModuleName) )
  {
    ModuleOn(sMyModuleName,
             100,
             100,
             100,
             100,
             1,
             1,
             1,
             "");
  }

  RootPanelOnModule(panels[1] + ".pnl",
                    "",
                    sMyModuleName,
                    makeDynString("$sDpName:" + deviceDpName,
                                  "$bHierarchyBrowser:FALSE") );
}

/** This function was only provided temporarily until the PVSS function
dpNames worked correctly in a distributed system when specifying a dp type.
Since this is now the case, the function is obsolete and has been updated
to use fully the dpNames call. It is recommended to use directly the PVSS
call.

@par Constraints
	None

@par Usage
	JCOP Framework internal

@par PVSS managers
	VISION, CTRL

@param dpPattern		pattern that the datapoint names should follow (e.g. CAEN/crate01/*)
@param dpType			desired datapoint type. No wildcards allowed (e.g. FwCaenBoard)
@param dps				datapoints that meet the specifier conditions for name and type
@param exceptionInfo details of any exceptions
*/
void fwDevice_dpNames(string dpPattern, string dpType, dyn_string &dps, dyn_string &exceptionInfo)
{
	// extract system part if exists...
	string sysName=fwSysName(dpPattern,false);
	sysName = (sysName!="" ? sysName+":" : getSystemName());

	unsigned sysId=getSystemId(sysName);
	if (sysId<0) return; // wrong system name...

	dyn_string dpts=dpTypes(dpType,sysId);
	if (dynlen(dpts)==0) return;  // dpType not present in remote system

	dps = dpNames(dpPattern, dpType);
}


/** Fills in the DP type of a device object

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device			device object
@param exceptionInfo	details of any exceptions
*/
fwDevice_fillDpType(dyn_string &device, dyn_string &exceptionInfo)
{
	if(device[fwDevice_DP_NAME] != "")
	{
//		DebugN("fwDevice_fillDpType ", device);
		device[fwDevice_DP_TYPE] = dpTypeName(device[fwDevice_DP_NAME]);
	}
}


/** This function will return the address parameters to be used when
configuring a device with the default addressing.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType			datapoint type of the device (e.g. FwCaenBoard)
@param addressParameters	returns a structure with the default address parameters, if they have been set
@param exceptionInfo		details of any exceptions
@param deviceModel			model of the device (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getAddressDefaultParams(string deviceDpType, dyn_string &addressParameters, dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "", string addressType=fwDevice_ADDRESS_DEFAULT)
{
	addressParameters[fwDevice_ADDRESS_TYPE] =fwDevice_ADDRESS_NONE; // initialize with at least some value...

	if (addressType == fwDevice_ADDRESS_DEFAULT) {
	    addressType = fwDevice_getDefaultAddressType(deviceDpType, exceptionInfo, deviceModel, deviceDpName, false);
	    if (dynlen(exceptionInfo)) return;
	    if (addressType!="") {
	    	addressParameters[fwDevice_ADDRESS_TYPE] = addressType;
	    } else {
	    	return;
	    }
	} else {
	    // make sure that address is supported
	    dyn_string availableAddressTypes;
	    fwDevice_getPossibleAddressTypes( deviceDpType, availableAddressTypes, exceptionInfo, deviceModel, deviceDpName);
	    if (!dynContains(availableAddressTypes,addressType)) {
		fwException_raise( exceptionInfo, "ERROR", "fwDevice_getAddressDefaultParams: address type " + addressType + " not supported.", "");
		return;
	    }
	}
	switch(addressType)
	{
		case fwDevice_ADDRESS_OPC:
			fwDevice_getAddressDefaultParamsOPC(deviceDpType, addressParameters, exceptionInfo, deviceModel);
			break;
		case fwDevice_ADDRESS_OPCUA:
			fwDevice_getAddressDefaultParamsOPCUA(deviceDpType, addressParameters, exceptionInfo, deviceModel);
			break;
		case fwDevice_ADDRESS_DIM:
			fwDevice_getAddressDefaultParamsDIM(deviceDpType, addressParameters, exceptionInfo, deviceModel);
			break;
		case fwDevice_ADDRESS_MODBUS:
			fwDevice_getAddressDefaultParamsMODBUS(deviceDpType, addressParameters, exceptionInfo, deviceModel);
			break;
		case fwDevice_ADDRESS_DIP:
			addressParameters[fwDevice_ADDRESS_TYPE]	= addressType;
			break;
		case fwDevice_ADDRESS_S7:
			fwDevice_getAddressDefaultParamsS7(deviceDpType, addressParameters, exceptionInfo, deviceModel);
			break;
		case fwDevice_ADDRESS_SNMP:
			fwDevice_getAddressDefaultParamsSNMP(deviceDpType, addressParameters, exceptionInfo, deviceModel);
			break;
		default:
			fwException_raise( exceptionInfo,"ERROR", "fwDevice_getAddressDefaultParams: address type " + addressType +" not supported.", "");
			addressParameters[fwDevice_ADDRESS_TYPE] = fwDevice_ADDRESS_NONE;
			break;
	}
}



/** This functions returns the address parameter to be used
by default when DIM is chosen as connection.

@par Constraints
	None

@par Usage
	Public

@PVSS managers
	VISION, CTRL

@param deviceDpType			datapoint type of the device (e.g. FwCaenBoard)
@param addressParameters	returns the default DIM parameters, if they have been set
@param exceptionInfo		details of any exceptions
@param deviceModel			model of the device (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getAddressDefaultParamsDIM(string deviceDpType, dyn_string &addressParameters, dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "")
{
	bool timeStamp;
	int driverNumber, timeInterval;
	string definitionDp;

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(	definitionDp + ".configuration.address.DIM.general.driverNumber", driverNumber,
			definitionDp + ".configuration.address.DIM.general.timeInterval", timeInterval,
			definitionDp + ".configuration.address.DIM.general.timeStamp", timeStamp);

	fwDevice_createDIMAddress(driverNumber, "", timeInterval, timeStamp, addressParameters, exceptionInfo);
}


/** This functions returns the address parameter to be used
by default when OPC is chosen as connection.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType			datapoint type of the device (e.g. FwCaenBoard)
@param addressParameters	returns the default OPC parameters, if they have been set
@param exceptionInfo		details of any exceptions
@param deviceModel			model of the device (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getAddressDefaultParamsOPC(string deviceDpType, dyn_string &addressParameters, dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "")
{
	int driverNumber;
	string serverName, groupIn, groupOut, definitionDp;

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(	definitionDp  + ".configuration.address.OPC.general.driverNumber", driverNumber,
			definitionDp  + ".configuration.address.OPC.general.serverName", serverName,
			definitionDp  + ".configuration.address.OPC.general.groupIn", groupIn,
			definitionDp  + ".configuration.address.OPC.general.groupOut", groupOut);

	fwDevice_createOPCAddress(	driverNumber, "", serverName, groupIn, groupOut,
								addressParameters, exceptionInfo);
}

/** This functions returns the address parameter to be used
by default when OPC UA is chosen as connection.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType			datapoint type of the device (e.g. FwCaenBoard)
@param addressParameters	returns the default OPC parameters, if they have been set
@param exceptionInfo		details of any exceptions
@param deviceModel			model of the device (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getAddressDefaultParamsOPCUA(string deviceDpType, dyn_string &addressParameters, dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "")
{
	int driverNumber;
	string serverName, subscriptionIn, subscriptionOut, definitionDp;

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(	definitionDp  + ".configuration.address.OPCUA.general.driverNumber", driverNumber,
			definitionDp  + ".configuration.address.OPCUA.general.serverName", serverName,
			definitionDp  + ".configuration.address.OPCUA.general.subscriptionIn", subscriptionIn,
			definitionDp  + ".configuration.address.OPCUA.general.subscriptionOut", subscriptionOut);

//DebugN("fwDevice_getAddressDefaultParamsOPCUA() " + "definitionDp: ", definitionDp, "| driverNumber: ",
//		driverNumber, "| serverName: ", serverName, "| subscriptionIn: ", subscriptionIn, "| subscriptionOut: ", subscriptionOut);


	fwDevice_createOPCUAAddress(	driverNumber, "", serverName, subscriptionIn, subscriptionOut,
								addressParameters, exceptionInfo);
}


/** This functions returns the address parameter to be used
by default when S7 is chosen as connection.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType			datapoint type of the device
@param addressParameters	returns the default OPC parameters, if they have been set
@param exceptionInfo		details of any exceptions
@param deviceModel			model of the device (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getAddressDefaultParamsS7(string deviceDpType, dyn_string &addressParameters,  dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "")
{
	int driverNumber, s7Start, s7SubIndex,s7Interval;
 string definitionDp;

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(	definitionDp  + ".configuration.address.S7.general.driverNumber", driverNumber,
			definitionDp  + ".configuration.address.S7.general.s7Start", s7Start,
			definitionDp  + ".configuration.address.S7.general.s7SubIndex", s7SubIndex,
			definitionDp  + ".configuration.address.S7.general.s7Interval", s7Interval
   );

	fwDevice_createS7Address(	driverNumber, s7Start, s7SubIndex, s7Interval,
								addressParameters, exceptionInfo);
}

/** This functions returns the address parameter to be used
by default when SNMP is chosen as connection.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType			datapoint type of the device
@param addressParameters	returns the default OPC parameters, if they have been set
@param exceptionInfo		details of any exceptions
@param deviceModel			model of the device (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getAddressDefaultParamsSNMP(string deviceDpType, dyn_string &addressParameters,  dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "")
{
	int driverNumber;
  string definitionDp;

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(definitionDp  + ".configuration.address.SNMP.general.driverNumber", driverNumber);

	addressParameters[fwDevice_ADDRESS_TYPE]          = fwDevice_ADDRESS_SNMP;
	addressParameters[fwDevice_ADDRESS_DRIVER_NUMBER] = driverNumber;
}

/** This functions returns the address parameter to be used
by default when MODBUS is chosen as connection.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType			datapoint type of the device
@param addressParameters	returns the default OPC parameters, if they have been set
@param exceptionInfo		details of any exceptions
@param deviceModel			model of the device (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getAddressDefaultParamsMODBUS(string deviceDpType, dyn_string &addressParameters,  dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "")
{
	int driverNumber;
  string definitionDp;

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(definitionDp  + ".configuration.address.MODBUS.general.driverNumber", driverNumber);

	addressParameters[fwDevice_ADDRESS_TYPE]          = fwDevice_ADDRESS_MODBUS;
	addressParameters[fwDevice_ADDRESS_DRIVER_NUMBER] = driverNumber;
}

/** Returns the dp elements that can have an address for a given device type and device model.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param elements			elements that can have an address
@param exceptionInfo	details of any exceptions
@param deviceModel		model of the device (e.g. A834P)
*/
fwDevice_getAddressElements(string deviceDpType, dyn_string &elements, dyn_string &exceptionInfo, string deviceModel = "")
{
	dyn_dyn_string elementsAndProperties;

	fwDevice_getConfigElements(deviceDpType, fwDevice_ADDRESS_INDEX, elementsAndProperties, exceptionInfo, deviceModel);
	elements = elementsAndProperties[1];
	//DebugN("Address elements " + elements);
}


/** Returns the label associated with the address mode (or direction) to be used for display to users.

@par Constraints
	Requires fwDevice_ADDRESS_MODE_TO_LABEL to be initialized

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param addressMode		address mode
@param label			label associated with the address mode
@param exceptionInfo	details of any exceptions
*/
fwDevice_getAddressModeLabel(int addressMode, string &label, dyn_string &exceptionInfo)
{
	if((addressMode == 0) || (addressMode > dynlen(fwDevice_ADDRESS_MODE_TO_LABEL)))
		label = "NONE";
	else
		label = fwDevice_ADDRESS_MODE_TO_LABEL[addressMode];
}


/** Returns the dp elements that can have an alert for a given device type and device model.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param elements			elements that can have an alert
@param exceptionInfo	details of any exceptions
@param deviceModel		model of the device (e.g. A834P)
*/
fwDevice_getAlertElements(string deviceDpType, dyn_string &elements, dyn_string &exceptionInfo, string deviceModel = "")
{
	dyn_dyn_string elementsAndProperties;

	fwDevice_getConfigElements(deviceDpType, fwDevice_ALERT_INDEX, elementsAndProperties, exceptionInfo, deviceModel);
	elements = elementsAndProperties[1];
	//DebugN("Alert elements " + elements);
}


/** Returns all the elements of a device type that can have an address, with the
items to which each element is connected and the address mode.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param addressType		selected address type(e.g. fwDevice_ADDRESS_OPC)
@param items			list with the address items
@param elements			list with the PVSS datapoint elements
@param modes			list with the adress modes
@param exceptionInfo	details of any exceptions
@param deviceModel		model of the device (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getAllItems(string deviceDpType, string addressType, dyn_string &items, dyn_string &elements, dyn_int &modes, dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "")
{
	int i;
	string definitionDp;
	dyn_int addressModes;
	dyn_string dpElements, localItems;


	switch(addressType)
	{
		case fwDevice_ADDRESS_NONE:
			return;
			break;
		case fwDevice_ADDRESS_OPC:
		case fwDevice_ADDRESS_DIM:
		case fwDevice_ADDRESS_MODBUS:
			break;
		default:
			fwException_raise(	exceptionInfo,
								"ERROR",
								"fwDevice_getItems: " + addressType + " address type not supported.",
								"");
			return;
	}

	items = makeDynString();
	elements = makeDynString();
	modes = makeDynString();

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(	definitionDp + fwDevice_ELEMENTS , dpElements,
			definitionDp + ".configuration.address." + addressType + ".direction", addressModes,
			definitionDp + ".configuration.address." + addressType + ".items" , localItems);

	for(i = 1; i <= dynlen(dpElements); i++)
	{
		if(addressModes[i] > 0)
		{
			dynAppend(items, localItems[i]);
			dynAppend(elements, dpElements[i]);
			dynAppend(modes, addressModes[i]);
		}
	}
}


/**	Returns all the datapoints that have been declared as
Framework devices. The declaration as a Framework device
requires only the existance of a definition for the device
(a datapoint of type _FwDeviceDefinition, named after the
datapoint type of the device and a suffix) and the following
dpes filled in the definition:
	<li> .type		(device type, e.g. CAEN Channel)
	<li> .dpType	(datapoint type, e.g. FwCaenBoard)

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param types			matrix containing the device types and the device datapoint types
							<li> types[1] = device types
							<li> types[2] = datapoint types
@param exceptionInfo	details of any exceptions
*/
fwDevice_getAllTypes(dyn_dyn_string &types, dyn_string &exceptionInfo)
{
	string deviceType, deviceDpType, defDp;
	dyn_string deviceDefinitionDps;

	deviceDefinitionDps = dpNames("*", "_FwDeviceDefinition");

	//DebugN("fwDevice_getAllTypes");
	for(int i = 1; i <= dynlen(deviceDefinitionDps); i++)
	{
		deviceType = "";
		deviceDpType = "";
		dpGet(deviceDefinitionDps[i] + ".type", deviceType);
		dpGet(deviceDefinitionDps[i] + ".dpType", deviceDpType);
		//DebugN(deviceDefinitionDps[i], deviceType, deviceDpType);
		defDp = dpSubStr(deviceDefinitionDps[i], DPSUB_DP);

		if(deviceDpType == "")
		{
			deviceDpType = substr(defDp, 0, strpos(defDp, fwDevice_DEFINITION_SUFIX));
		}

		if(deviceType == "")
		{
			deviceType = substr(defDp, 0, strpos(defDp, fwDevice_DEFINITION_SUFIX));
		}

		types[1][i] = deviceType;
		types[2][i] = deviceDpType;
	}
}


/**	Returns the Framework default archive class. For the moment
this is constant for all device types

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param archiveClass		archiver to be used
@param exceptionInfo	details of any exceptions
*/
fwDevice_getArchiveClass(string deviceDpType, string &archiveClass, dyn_string &exceptionInfo)
{
	archiveClass = 	fwDevice_ARCHIVE_CLASS;
}

/** Returns the dp elements that can be archived for a given device.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param elements			elements that can be archived
@param exceptionInfo	details of any exceptions
@param deviceModel 		model of the device (e.g. A834P)
*/
fwDevice_getArchiveElements(string deviceDpType, dyn_string &elements, dyn_string &exceptionInfo, string deviceModel = "")
{
	dyn_dyn_string elementsAndProperties;

	fwDevice_getConfigElements(deviceDpType, fwDevice_ARCHIVE_INDEX, elementsAndProperties, exceptionInfo, deviceModel);
	elements = elementsAndProperties[1];
}


/** Get all the children devices of a device

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device			datapoint name or datapoint alias of the device
@param type				type of hierarchy (fwDevice_HARDWARE or fwDevice_LOGICAL)
@param children			list of child devices
@param exceptionInfo	details of any exception
*/
fwDevice_getChildren(string device, string type, dyn_string &children, dyn_string &exceptionInfo)
{
	bool sort = FALSE;
	int i, length;
	string deviceDpName, searchPattern, childPattern, prefix = "";
	dyn_string rawResult;

	children = makeDynString();

//	DebugN("fwDevice_getChildren children of " + device + " hierarchy type " + type);

	switch(type)
	{
		case fwDevice_HARDWARE:
		{
			// check that system name was given, if not use the local one
			deviceDpName = dpSubStr(device, DPSUB_SYS_DP);
			if(!dpExists(deviceDpName))
			{
				fwException_raise(	exceptionInfo,
									"ERROR",
									"fwDevice_getChildren(): the device " + deviceDpName + " does not exist",
									"");
				return;
			}
			searchPattern = deviceDpName + fwDevice_HIERARCHY_SEPARATOR + "*";
			rawResult = dpNames(searchPattern);
			childPattern = searchPattern + fwDevice_HIERARCHY_SEPARATOR + "*";
			break;
		}
		case fwDevice_LOGICAL:
		{
			string systemName;
			sort = TRUE;

			deviceDpName = dpSubStr(dpAliasToName(device), DPSUB_SYS_DP);
//			DebugN("fwDevice_getChildren: device " + device + " deviceDpName " + deviceDpName + "  " + dpAliasToName(device));

			systemName = substr(device, 0, strpos(device, ":") + 1);
			prefix = systemName;

			// if device doesn't exists, try to see if what was passed was a datapoint name, not an alias
			if(!dpExists(deviceDpName))
			{
				deviceDpName = device;
				device = dpGetAlias(deviceDpName + ".");
//				DebugN("fwDevice_getChildren: device " + device + " deviceDpName " + deviceDpName + "  " + dpAliasToName(device));
			}

			if(!dpExists(deviceDpName))
			{
				fwException_raise(	exceptionInfo,
									"ERROR",
									"fwDevice_getChildren(): the alias " + device + " is not mapped to any device",
									"");
				return;
			}
			//DebugN("device before removinf system name: " + device);
			// remove system name if given since dpAliases doesn't work with the system name
			device = substr(device, strpos(device, ":") + 1);
			//DebugN("fwDevice_getChildren(): deviceDpAlias " + device + " deviceDpName " + deviceDpName + " systemName " + systemName);

			if((systemName == getSystemName()) || (systemName == ""))
			{
				// if it is the local system take advantage of dpAliases
				searchPattern = device + fwDevice_HIERARCHY_SEPARATOR + "*";
				rawResult = dpAliases(searchPattern);
				childPattern = searchPattern + fwDevice_HIERARCHY_SEPARATOR + "*";
			}
			else
			{
				// if it is a remote system dpAliases cannot be used
				// dpNames is used instead, but it returns dp names, not dp aliases

				searchPattern = systemName + "@" + device + fwDevice_HIERARCHY_SEPARATOR + "*";
				rawResult = dpNames(searchPattern);
				//DebugN("fwDevice_getChildren: rawResult after dpNames" + rawResult);
				rawResult = dpGetAlias(rawResult);
				//DebugN("fwDevice_getChildren: rawResult after dpGetAlias" + rawResult);
				childPattern = device + fwDevice_HIERARCHY_SEPARATOR + "*" + fwDevice_HIERARCHY_SEPARATOR + "*";
			}
			//DebugN("fwDevice_getChildren(): rawResult " + rawResult);
			break;
		}
		default:
			fwException_raise(	exceptionInfo,
								"ERROR",
								"fwDevice_getChildren(): not supported hierarchy type " + type,
								"");

			break;
	}

	//DebugN("Raw result");
	length = dynlen(rawResult);
	//pattern = pattern + fwDevice_HIERARCHY_SEPARATOR + "*";
	for(i = 1; i <= length; i++)
	{
		if(!(patternMatch(childPattern, rawResult[i])))
		{
			//DebugN("Pattern didn't match " + rawResult[i]);
			dynAppend(children, prefix + rawResult[i]);
		}
	}

	// sort children if logical (aliases sometimes are not in alphabetical order)
	if(sort)
		dynSortAsc(children);

	//DebugN("fwDevice_getChildren children of " + device + " are " + children);
	//DebugN("fwDevice_getChildren: rawResult " + rawResult);
	//DebugN("hierarchyType " + type);
}


/** Gets the possible dp types that a device can have as children.
It is a combination of fwDevice_getModelChildrenDpTypes (gets the possible children
for the model) and fwDevice_getPossibleDpTypes (gets the possible children
for the dp type). It will first try the model and if there are no possible children
then try the dp type.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device			device object (only the dp type or dp name is required)
@param childrenDpTypes	possible children dp types
@param exceptionInfo	details of any exceptions are returned here, indicating if the address is correct
*/
fwDevice_getChildrenDpTypes(dyn_string device, dyn_string &childrenDpTypes, dyn_string &exceptionInfo)
{
	dyn_string dpTypesList;
	bool canHaveChildren = FALSE;

	childrenDpTypes = makeDynString();

	// try for the model
	//DebugN("fwDevice_getChildrenDpTypes(): device " + device);
	fwDevice_getModelChildrenDpTypes(device, dpTypesList, exceptionInfo);

	// if the children dp types are not defined for the model, try for the type
	if((dynlen(dpTypesList) == 0) || (dynlen(exceptionInfo) > 0))
	{
		fwDevice_fillDpType(device, exceptionInfo);
		fwDevice_getPossibleChildrenDpTypes(device[fwDevice_DP_TYPE], dpTypesList, exceptionInfo);
	}

	//DebugN("fwDevice_getChildrenDpTypes(): dpTypesList " + dpTypesList + " " + exceptionInfo);

	childrenDpTypes = dpTypesList;
}


/** Get all the children devices of a device ordered in slots

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device		device object
@param type		type of hierarchy fwDevice_HARDWARE or fwDevice_LOGICAL
@param orderedChildren	list of child devices ordered in slots
@param exceptionInfo	details of any exception
*/
fwDevice_getChildrenInSlots(dyn_string device, string type, dyn_string &orderedChildren, dyn_string &exceptionInfo)
{
	int i, position, positionIndex, slots, startingNumber;
	string name, model;
	dyn_string children;

	fwDevice_getModel(device, model, exceptionInfo);
	if(dynlen(exceptionInfo)) return;
	if (model=="") {
	    fwException_raise(exceptionInfo,"ERROR","fwDevice_getChildrenInSlots():Unknown model for device:"+(string)device,"");
	    return;
	}

	if (!dynlen(exceptionInfo)) fwDevice_getModelSlots(device, slots, exceptionInfo);
	if (!dynlen(exceptionInfo)) fwDevice_getModelStartingNumber(device, startingNumber, exceptionInfo);
	if (!dynlen(exceptionInfo)) fwDevice_getChildren(device[fwDevice_DP_NAME], type, children, exceptionInfo);

	if (dynlen(exceptionInfo)) return;

	DebugFTN("FW_INFO", "fwDevice_getChildrenInSlots(): slots " + slots + " startingNumber " + startingNumber + " device " + device);

	if(slots != 0)
	{
		// initialize list of children
		for(i = 1; i <= slots; i++)
		{
			orderedChildren[i] = "";
		}
		//orderedChildren = makeDynString();

		// order the children
		for(i = 1; i <= dynlen(children); i++)
		{
			fwDevice_getPosition(children[i], name, position, exceptionInfo);
			// add 1 to be able to start from 0
			positionIndex = position + 1 - startingNumber;
			if(positionIndex < 1)
			{
				fwException_raise(exceptionInfo,
										"ERROR",
										"fwDevice_getChildrenInSlots(): found device in non allowed slot. ",
										"");
			}
			else
			{
				orderedChildren[positionIndex] = children[i];
			}
		}
	}
	else
	{
		// if the model hasn't got slots, just return the children as they are
		orderedChildren = children;
	}
}


/** For a given device type and device model, returns its datapoint elements
that can have a specific config, based on the device definition.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param configIndex			selected config. Has to be one of the supported config indexes (SUPPORTED_CONFIGS)
@param elements			structure with the dpes and the correspondent device property name
							<li>elements[fwDevice_ELEMENTS_INDEX] dp elements that can have the selected config
							<li>elements[fwDevice_PROPERTY_NAMES_INDEX] property names for the above elements
							<li>elements[fwDevice_USER_DATA_INDEX] user data for the above elements
							<li>elements[fwDevice_DESCRIPTION_INDEX] description for the above elements
@param exceptionInfo	details of any exceptions
@param deviceModel		model of the device (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getConfigElements(string deviceDpType, int configIndex, dyn_dyn_string &elements, dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "")
{
	int i;
	string definitionDp;
	dyn_bool allowedElements;
	dyn_string deviceElements, propertiesNames, userData, modelDp, description;

	if (((configIndex < MIN_CONFIG_INDEX) || (configIndex > MAX_CONFIG_INDEX)) && (configIndex != fwDevice_ALL))
	{
		fwException_raise(exceptionInfo,
								"ERROR",
								"fwDevice_getConfigElements(): config not supported",
								"");
		return;
	}

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	//DebugN("fwDevice_getConfigElements(): found definition DP: " + definitionDp);
	if(definitionDp == "")
	{
		fwException_raise(exceptionInfo,
								"ERROR",
								"fwDevice_getConfigElements(): could not find definition DP for device type " + deviceDpType + " and model " + deviceModel,
								"");
		return;
	}

	// Get the appropriate elements
	if (configIndex == fwDevice_ALL)
	{
		dpGet(definitionDp + fwDevice_ELEMENTS, deviceElements,
				definitionDp + fwDevice_PROPERTY_NAMES, propertiesNames,
				definitionDp + fwDevice_USER_DATA, userData,
				definitionDp + fwDevice_DESCRIPTION, description);

		elements[fwDevice_ELEMENTS_INDEX] 		= deviceElements;
		elements[fwDevice_PROPERTY_NAMES_INDEX] = propertiesNames;

		// fill in data that might be incomplete
		fwGeneral_fillDynString(userData, dynlen(deviceElements), exceptionInfo);
		elements[fwDevice_USER_DATA_INDEX] = userData;

		fwGeneral_fillDynString(description, dynlen(deviceElements), exceptionInfo);
		elements[fwDevice_DESCRIPTION_INDEX] = description;

	}
	else
	{
		dpGet(	definitionDp + fwDevice_ELEMENTS, deviceElements,
				definitionDp + fwDevice_PROPERTY_NAMES, propertiesNames,
				definitionDp + fwDevice_USER_DATA, userData,
				definitionDp + fwDevice_DESCRIPTION, description,
				definitionDp + fwDevice_CONFIG_CAN_HAVE[configIndex], allowedElements);

		// fill in data that might be incomplete
		fwGeneral_fillDynString(userData, dynlen(deviceElements), exceptionInfo);
		elements[fwDevice_USER_DATA_INDEX] = userData;

		fwGeneral_fillDynString(description, dynlen(deviceElements), exceptionInfo);
		elements[fwDevice_DESCRIPTION_INDEX] = description;

		elements[fwDevice_ELEMENTS_INDEX] 		= makeDynString();
		elements[fwDevice_PROPERTY_NAMES_INDEX] = makeDynString();
		elements[fwDevice_USER_DATA_INDEX] 		= makeDynString();
		for(i = 1; i <= dynlen(deviceElements); i++)
		{
			if (allowedElements[i])
			{
				dynAppend(elements[fwDevice_ELEMENTS_INDEX],		deviceElements[i]);
				dynAppend(elements[fwDevice_PROPERTY_NAMES_INDEX],	propertiesNames[i]);
				dynAppend(elements[fwDevice_USER_DATA_INDEX],		userData[i]);
			}
		}
	}
	//DebugN("Elements " + elements);
}

/** For a given device type and device model, returns the definition
information for the specific config, based on the device definition.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param configIndex			selected config. It has to be one of the supported config indexes (SUPPORTED_CONFIGS)
@param objects			array of objects with selected config data for each device property
@param exceptionInfo	details of any exceptions
@param deviceModel		model of the device (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getConfigObjects(string deviceDpType, int configIndex, dyn_dyn_string &objects, dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "")
{
	int i, j, objectsIndex = 1;
	string definitionDp;
	dyn_bool allowedElements;
	dyn_string deviceElements, propertiesNames, dsAux;
	dyn_dyn_string definitions;

	if (((configIndex < MIN_CONFIG_INDEX) || (configIndex > MAX_CONFIG_INDEX)) && (configIndex != fwDevice_ALL))
	{
		fwException_raise(	exceptionInfo,
							"ERROR",
							"fwDevice_getConfigObjects(): config not supported",
							"");
	}

	// Check if device definition exists
	if (!dpExists(deviceDpType + fwDevice_DEFINITION_SUFIX))
	{
		fwException_raise(	exceptionInfo,
							"ERROR",
							"fwDevice_getConfigObjects(): device definition info does not exist for " + deviceDpType,
							"");
		return;
	}

	if (configIndex == fwDevice_ALL)
	{
		fwException_raise(	exceptionInfo,
							"ERROR",
							"fwDevice_getConfigObjects(): it is not possible to retrieve all config objects.",
							"");
		return;
	}
	else
	{
		fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
		if(definitionDp == "")
			return;

		// Get the appropriate elements
		dpGet(	definitionDp + fwDevice_ELEMENTS, deviceElements,
				definitionDp + fwDevice_PROPERTY_NAMES, propertiesNames,
				definitionDp + fwDevice_CONFIG_CAN_HAVE[configIndex], allowedElements);
		//DebugN("fwDevice_CONFIG_ATTRIBUTES_DEFINITION[configIndex] " + fwDevice_CONFIG_ATTRIBUTES_DEFINITION[configIndex]);
		for(i = 1; i <= dynlen(fwDevice_CONFIG_ATTRIBUTES_DEFINITION[configIndex]); i++)
		{
			//DebugN("deviceDpType + fwDevice_DEFINITION_SUFIX + fwDevice_CONFIG_ATTRIBUTES_DEFINITION[configIndex][i]" +deviceDpType + fwDevice_DEFINITION_SUFIX + fwDevice_CONFIG_ATTRIBUTES_DEFINITION[configIndex][i]);
			dpGet(definitionDp + fwDevice_CONFIG_ATTRIBUTES_DEFINITION[configIndex][i], dsAux);
			definitions[i] = dsAux;
			//DebugN(definitions[i], dsAux);
		}

		//DebugN("definitions " + definitions);
		objects = makeDynString();
		for(i = 1; i <= dynlen(deviceElements); i++)
		{
			if (allowedElements[i])
			{
				objects[objectsIndex][fwDevice_CONFIG_PROPERTY] = propertiesNames[i];
				objects[objectsIndex][fwDevice_CONFIG_DPE] = deviceElements[i];
				for(j = 1; j <= dynlen(definitions); j++)
				{
					objects[objectsIndex][fwDevice_CONFIG_MAX_INDEX + j] = definitions[j][i];
				}
				objectsIndex++;
			}
		}
	}
	//DebugN("Elements " + elements);
}


/** For a given device type and device model, returns its datapoint elements
that can have a conversion config, based on the device definition.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param elements			elements that can have conversion
@param exceptionInfo	details of any exceptions
@param deviceModel		model of the device (e.g. A834P)
*/
fwDevice_getConversionElements(string deviceDpType, dyn_string &elements, dyn_string &exceptionInfo, string deviceModel = "")
{
	dyn_dyn_string elementsAndProperties;

	fwDevice_getConfigElements(deviceDpType, fwDevice_CONVERSION_INDEX, elementsAndProperties, exceptionInfo, deviceModel);
	elements = elementsAndProperties[1];
	//DebugN("Alert elements " + elements);
}

/** Returns the default expert configuration panel for
a specific device type and device model.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param panel			default expert configuration panel
@param exceptionInfo	details of any exceptions
@param deviceModel		model of the device (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getDefaultConfigurationExpertPanels(string deviceDpType, string &panel, dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "")
{
	string definitionDp;

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(definitionDp + ".panels.editor.expert", panel);
}


/**	Returns the default logical configuration panels for
a specific device type and device model.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param panels			default logical configuration panels
@param exceptionInfo	details of any exceptions
@param deviceModel		model of the device (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getDefaultConfigurationLogicalPanels(string deviceDpType, dyn_string &panels, dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "")
{
	string definitionDp;

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(definitionDp + ".panels.editor.logical", panels);
}

/**	Returns the default hardware configuration panels for
a specific device type and device model.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param panels			default hardware configuration panels
@param exceptionInfo	details of any exceptions
@param deviceModel		model of the device (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.

*/
fwDevice_getDefaultConfigurationPanels(string deviceDpType, dyn_string &panels, dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "")
{
	string definitionDp;

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(definitionDp + ".panels.editor.hardware", panels);
}


/** Returns the default name for a given device dp type and device
model, in a given position in its parent. The name is built with the
information contained in the device definition.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device			device object. It has to contain either the device dp type, or the device dp type
						and the	device dp model if one wants to include model specific characteristics.
@param position			position of the device in the parent
@param defaultName		default name
@param exceptionInfo	details of any exceptions
*/
fwDevice_getDefaultName(dyn_string device, int position, string &defaultName, dyn_string &exceptionInfo)
{
	int nameDigits;
	string nameRoot;

	defaultName = "";
	if(device[fwDevice_MODEL] != "")
	{
		dyn_string modelDp;
		fwDevice_getModelDp(device, modelDp, exceptionInfo);
//		DebugN("fwDevice_getDefaultName ", modelDp);
		if(dynlen(modelDp) != 3)
			return;
		dpGet(	modelDp[1] + ".general.nameRoot", nameRoot,
				modelDp[1] + ".general.nameDigits", nameDigits);
	}
	else
	{
		if(device[fwDevice_DP_TYPE] != "")
		{
			dpGet(	device[fwDevice_DP_TYPE] + fwDevice_DEFINITION_SUFIX + ".general.nameRoot", nameRoot,
					device[fwDevice_DP_TYPE] + fwDevice_DEFINITION_SUFIX + ".general.nameDigits", nameDigits);
		}
		else
		{
			fwException_raise(	exceptionInfo,
								"ERROR",
								"fwDevice_getDefaultName(): either the device dp type or the device dp type and the model have to be specified.",
								"");
			return;
		}
	}

	if(nameRoot != "")
		sprintf(defaultName, "%s%0" + nameDigits + "d", nameRoot, position);
}


/**	Returns the default logical operation panels for
a specific device type and device model.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param panels			default logical operation panels
@param exceptionInfo	details of any exceptions
@param deviceModel		model of the device (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getDefaultOperationLogicalPanels(string deviceDpType, dyn_string &panels, dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "")
{
	string definitionDp;

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(definitionDp + ".panels.navigator.logical", panels);
}


/**	Returns the default hardware operation panels for
a specific device type and device model.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param panels			default hardware operation panels
@param exceptionInfo	details of any exceptions
@param deviceModel		model of the device (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getDefaultOperationPanels(string deviceDpType, dyn_string &panels, dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "")
{
	string definitionDp;

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(definitionDp + ".panels.navigator.hardware", panels);
}

/** Returns the dp that has to be read to get the definition to
be used to configure the device. The dp can be linked to the
device type or to the device model

@par Constraints
	None

@par Usage
	JCOP Framework internal

@par PVSS managers
	VISION, CTRL

@param device			device object. It has to contain the device dp name, the device dp type, or the device dp type
						and the	device dp model if one wants to include model specific characteristics.
@param definitionDp		dp (or structure dpe) containing the definition to be used for the device object
@param exceptionInfo	details of any exceptions
*/
fwDevice_getDefinitionDp(dyn_string device, string &definitionDp, dyn_string &exceptionInfo)
{
	bool useModelDefinition;
	string system;
	dyn_string modelDp;

//	DebugN("fwDevice_getDefinitionDp(): device before is: " + device);
	definitionDp = "";
	fwDevice_getModelDp(device, modelDp, exceptionInfo);

//	DebugN("fwDevice_getDefinitionDp(): modelDp: " + modelDp + " " + dynlen(modelDp));

	// if there is a model dp, see if it can be used for definition
	if(dynlen(modelDp) > 0)
	{
		dpGet(modelDp[1] + ".modelDefinition.useModelDefinition", useModelDefinition);
		if(useModelDefinition)
		{
			definitionDp = modelDp[1] + ".modelDefinition.definition";
		}
	}

//	DebugN("fwDevice_getDefinitionDp(): definition dp is: " + definitionDp + ".");

	// use device type definition (when there is no model, or the model dp doesn't contain definition)
	if(definitionDp == "")
	{
		// fill in type information
		fwDevice_fillDpType(device, exceptionInfo);
		definitionDp = device[fwDevice_DP_TYPE] + fwDevice_DEFINITION_SUFIX;
	}

//	DebugN("fwDevice_getDefinitionDp(): definition dp is: " + definitionDp + ".");

	// if definition dp does not exist, try to get it from the system where the device is
	if(!dpExists(definitionDp))
	{
		if(device[fwDevice_DP_NAME] != "")
		{
			system = dpSubStr(device[fwDevice_DP_NAME], DPSUB_SYS);
			definitionDp = system + definitionDp;
		}
	}

//	DebugN("fwDevice_getDefinitionDp(): definition dp is: " + definitionDp + ".");

	// if definition dp still doesn't exist return an empty string
	if(!dpExists(definitionDp))
	{
		definitionDp = "";
		// Don't raise exception as it is not an error
		// fwException_raise(exceptionInfo, "ERROR", "fwDevice_getDefinitionDp(): could not find definition dp for " + device, "");
	}

//	DebugN("fwDevice_getDefinitionDp(): device after is: " + device);
//	DebugN("fwDevice_getDefinitionDp(): definition dp is: " + definitionDp);
//	DebugN("fwDevice_getDefinitionDp(): modelDp: " + modelDp);
//	DebugN("fwDevice_getDefinitionDp(): useModelDefinition: " + useModelDefinition);
}


/** For a given device type and device model, returns its datapoint elements
that can have a dp function config, based on the device definition.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param elements			elements that can have a dp function
@param exceptionInfo	details of any exceptions
@param deviceModel		model of the device (e.g. A834P)
*/
fwDevice_getDpFunctionElements(string deviceDpType, dyn_string &elements, dyn_string &exceptionInfo, string deviceModel = "")
{
	dyn_dyn_string elementsAndProperties;

	fwDevice_getConfigElements(deviceDpType, fwDevice_DPFUNCTION_INDEX, elementsAndProperties, exceptionInfo, deviceModel);
	elements = elementsAndProperties[1];
}


/** Returns the PVSS datapoint type associated with the given
Framework device type.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceType		device type
@param deviceDpType		device datapoint type
@param exceptionInfo	details of any exceptions
*/
fwDevice_getDpType(string deviceType, string &deviceDpType, dyn_string &exceptionInfo)
{
	int i;
	string aux;
	dyn_string deviceDefinitions = dpNames("*", "_FwDeviceDefinition");

	i = 1;
	deviceDpType = "";
	while((deviceDpType == "") && (i <= dynlen(deviceDefinitions)))
	{
		dpGet(deviceDefinitions[i] + ".type", aux);
		if (aux == deviceType)
		{
			dpGet(deviceDefinitions[i] + ".dpType", deviceDpType);
		}
		i++;
	}
}


/** For a given device type and device model, returns a list of its datapoint
elements and the correspondent PVSS address mode.

@par Constraints
	Currently only works with OPC addresses.

@par Usage
	JCOP Framework internal

@par PVSS managers
	VISION, CTRL

@param deviceDpType		device datapoint type (e.g. FwCaenBoard)
@param elements			list of datapoint elements
@param mode				list of PVSS address modes correpondent to the datapoint elements
@param exceptionInfo	details of any exceptions
@param deviceModel		device model (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getElements(string deviceDpType, dyn_string &elements, dyn_int &mode, dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "")
{
	string definitionDp;

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(	definitionDp + fwDevice_ELEMENTS, elements,
			definitionDp + ".configuration.address.OPC.direction" , mode);
}

/** For a given device datapoint and device model, and a datapoint element inside
the datapoint type, the function returns a list with the PVSS configs that the
datapoint element can have.

@par Constraints
	the device must be of one of the valid framework types

@par Usage
	Public

@par PVSS managers:
	VISION, CTRL

@param deviceDpType			device datapoint type from which info is requested (e.g. FwCaenBoard)
@param dpElement			datapoint element inside the devive datapoint type
@param possibleConfigs		boolean list that indicates the possible configs. Each position in the array
							correponds to one of the supported configs indexes defined in the begining
							of this file (fwDevice_ADDRESS_INDEX, etc)
@param exceptionInfo		returns details of any exceptions
@param deviceModel			device model (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getElementPossibleConfigs(	string deviceDpType, string dpElement, dyn_bool &possibleConfigs,
									dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "")
{
	int i, index;
	string definitionDp;
	dyn_bool canHaveConfig;
	dyn_int mode;
	dyn_string deviceElements;
	dyn_dyn_string propeAndProperties;

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	// Find out index of element in the list of elements for the device.
	dpGet(definitionDp + fwDevice_ELEMENTS, deviceElements);
	index = dynContains(deviceElements, dpElement);
	if (index <= 0)
	{
		fwException_raise(	exceptionInfo,
							"ERROR",
							"fwDevice_getElementPossibleConfigs(): the device dp type " + deviceDpType + "doesn't have the dp element " + dpElement,
							"");
		return;
	}

	// Find which configs can it have
	for ( i = MIN_CONFIG_INDEX; i <= MAX_CONFIG_INDEX; i++)
	{
		if (fwDevice_CONFIG_CAN_HAVE[i] != "")
		{
			dpGet(definitionDp + fwDevice_CONFIG_CAN_HAVE[i], canHaveConfig);
			possibleConfigs[i] = canHaveConfig[index];
		}
		else
		{
			possibleConfigs[i] = FALSE;
		}
	}
}


/** For a given device type and device model, returns its datapoint elements
that can have a format defined, based on the device definition.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param elements			elements that can have a dp function
@param exceptionInfo	details of any exceptions
@param deviceModel		model of the device (e.g. A834P)
*/
fwDevice_getFormatElements(string deviceDpType, dyn_string &elements, dyn_string &exceptionInfo, string deviceModel = "")
{
	dyn_dyn_string elementsAndProperties;

	fwDevice_getConfigElements(deviceDpType, fwDevice_FORMAT_INDEX, elementsAndProperties, exceptionInfo, deviceModel);
	elements = elementsAndProperties[1];
}


/** Returns a list of the available slots in the
device.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device			device object
@param freeSlots		freeSlots currently available in the device
@param exceptionInfo	details of any exceptions
*/
fwDevice_getFreeSlots(dyn_string device, dyn_int &freeSlots, dyn_string &exceptionInfo)
{
	int width;
	string aux;
	dyn_string orderedChildren;
	dyn_dyn_string modelProperties;

	fwDevice_getChildrenInSlots(device, fwDevice_HARDWARE, orderedChildren, exceptionInfo);

	DebugFTN(	"FW_INFO", "fwDevice_getFreeSlots(): device = " + device + " orderedChildren = " + orderedChildren);

	freeSlots = makeDynInt();
	// go thorough the children to see empty slots
	for(int i = 1; i <= dynlen(orderedChildren);)
	{
		if(orderedChildren[i] != "")
		{
			fwDevice_getModelProperties(makeDynString(orderedChildren[i]), modelProperties, exceptionInfo);
			aux = modelProperties[fwDevice_MODEL_WIDTH];
			width = (int) aux;
			if(width <= 0)
				width = 1;
			i = i + width;
			//DebugN("width " + width);
		}
		else
		{
			dynAppend(freeSlots, i);
			i++;
		}
	}

	DebugFTN(	"FW_INFO", "fwDevice_getFreeSlots(): device = " + device + " exceptionInfo = " + exceptionInfo);
}

/**Goes through the device dp name and to returns the full hierarchy above
it with device names and positions.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName			dp name of the device (e.g. CAEN/crate003/board07/channel005)
@param deviceHierarchy		structure containing the hierarchy from the given device going to its parent, grandparent, ect.
							Each row in the dyn_dyn_string has the following structure:
							<ol>
								<li> device dp name
								<li> device position as string (keeping trailing 0s)
								<li> device position as int
							</ol>
							So for example, deviceHierarchy[3][1] will contain the device dp name of the grandparent.
@param exceptionInfo		details of any exceptions
*/
fwDevice_getHierarchy(string deviceDpName, dyn_dyn_string &deviceHierarchy, dyn_string &exceptionInfo) {
  if (strlen(deviceDpName) == 0) {
    fwException_raise(exceptionInfo, "ERROR", "Device DP name is blank", "");
  }
	string posDpName = deviceDpName, currentString;
	dyn_string dsAux = strsplit(deviceDpName, fwDevice_HIERARCHY_SEPARATOR);
  int dynLen = dynlen(dsAux);
	deviceHierarchy = makeDynString("");
	for (int i = 1; i <= dynLen; i++) {
		currentString = dsAux[dynLen - i + 1];
		deviceHierarchy[i][1] = posDpName;

    string posString;
    bool   isStarted;

    for (int j = strlen(currentString) - 1; j >= 0; j--) {
      bool isNumber = currentString[j] >= 48 /*ASCII 0*/ && currentString[j] <= 57 /*ASCII 9*/;

      if (!isNumber) {
        if (isStarted || currentString[j] == ":"/* system_name: */) {
          break;
        }
      } else {
        isStarted = true;
        posString = currentString[j] + posString;
      }
    }

    deviceHierarchy[i][2] = posString;
    if (isStarted) {
    	deviceHierarchy[i][3] = (int)posString;
    } else {
      deviceHierarchy[i][3] = "";
    }
		posDpName = substr(posDpName, 0, strlen(posDpName) - strlen(fwDevice_HIERARCHY_SEPARATOR + currentString));
	}
}

/**	Returns the panels asscociated with a device instance.
At the moment, the only device that can have a panel associated
to an instance is the Node (FwNode)

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName		device datapoint name
@param mode				whether Navigator or Editor mode panels are wanted
@param panelList		list with the panels
@param exceptionInfo	details of any exceptions
*/
fwDevice_getInstancePanels(string deviceDpName, string mode, dyn_string &panelList, dyn_string &exceptionInfo)
{
	string dpElement;

	switch(mode)
	{
		case fwDEN_MODE_NAVIGATOR:
			dpElement = ".navigatorPanels";
			break;
		case fwDEN_MODE_EDITOR:
			dpElement = ".editorPanels";
			break;
		default:
			break;
	}

	dpGet(deviceDpName + dpElement, panelList);
}


/** For a given device type and device model, and a requested address direction,
returns a list of items and its associated datapoint elements, based on the device
definition.

@par Constraints
	None

@par Usage
	Public

PVSS manager usage: VISION, CTRL

@param deviceDpType		device datapoint type (e.g. FwCaenBoard)
@param addressType		address type (e.g. fwDevice_ADDRESS_OPC)
@param direction		direction of the requested items:
							<li> Input: "IN" or fwDevice_ADDRESS_DPES_INPUT
							<li> Output: "OUT" or fwDevice_ADDRESS_DPES_OUTPUT
							<li> Input/Output: fwDevice_ADDRESS_DPES_INPUT_OUTPUT
@param items			list of items of the requested address type
@param elements			list of elements correspondent to the list of items
@param exceptionInfo	details of any exceptions
@param deviceModel		device model (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getItems(	string deviceDpType, string addressType, string direction, dyn_string &items, dyn_string &elements, dyn_string &exceptionInfo,
					string deviceModel = "", string deviceDpName = "")
{
	int i;
	string definitionDp;
	dyn_int addressModes, requestedModes;
	dyn_string dpElements, localItems;

	switch(strtoupper(direction))
	{
		case "IN":
		case fwDevice_ADDRESS_DPES_INPUT:
			requestedModes = fwDevice_ADDRESS_DIR_INPUT;
			break;
		case "OUT":
		case fwDevice_ADDRESS_DPES_OUTPUT:
			requestedModes = fwDevice_ADDRESS_DIR_OUTPUT;
			break;
		case fwDevice_ADDRESS_DPES_INPUT_OUTPUT:
			requestedModes = fwDevice_ADDRESS_DIR_INPUT_OUTPUT;
			break;
		default:
			fwException_raise(	exceptionInfo,
								"ERROR",
								"fwDevice_getItems: direction has to be in, out or " + fwDevice_ADDRESS_DIR_INPUT_OUTPUT + " (not case sensitive)",
								"");
			return;
	}

	switch(addressType)
	{
		case fwDevice_ADDRESS_NONE:
			return;
			break;
		case fwDevice_ADDRESS_OPC:
		case fwDevice_ADDRESS_DIM:
		case fwDevice_ADDRESS_MODBUS:
			break;
		default:
			fwException_raise(	exceptionInfo,
								"ERROR",
								"fwDevice_getItems: " + addressType + " address type not supported.",
								"");
			return;
	}

	items = makeDynString();
	elements = makeDynString();

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(	definitionDp + fwDevice_ELEMENTS , dpElements,
			definitionDp + ".configuration.address." + addressType + ".direction", addressModes,
			definitionDp + ".configuration.address." + addressType + ".items" , localItems);

	for(i = 1; i <= dynlen(dpElements); i++)
	{
		if (dynContains(requestedModes, addressModes[i]))
		{
			dynAppend(items, localItems[i]);
			dynAppend(elements, dpElements[i]);
		}
	}
}

/** Gets all the leaf devices in the hardware hierarchy below below a given device.

@par Constraints
	Works only for the hardware hierarchy.

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName		device datapoint name
@param leafs			list of devices that are leafs in the hierarchy below deviceDpName
@param exceptionInfo	details of any exceptions
*/
fwDevice_getLeafs(string deviceDpName, dyn_string &leafs, dyn_string &exceptionInfo)
{
	int i;
	dyn_string children;

	fwDevice_getChildren(deviceDpName, fwDevice_HARDWARE, children, exceptionInfo);
	if(dynlen(children) == 0)
		dynAppend(leafs, deviceDpName);

	for(i = 1; i <= dynlen(children); i++)
	{
		fwDevice_getLeafs(children[i], leafs, exceptionInfo);
	}
}


/** Returns the model information for a given device object.

@param device		device object. Only the device datapoint name is relevant.
@param model		returns the device model if it exists; empty string if deviceDP exists but has no model
                        (e.g. non-Fw device)
@param exceptionInfo	exception details, on non-existing DP or invalid structure of the device parameter
*/
fwDevice_getModel(dyn_string device, string &model, dyn_string &exceptionInfo)
{
	if (dynlen(device) < fwDevice_DP_NAME) {
	    fwException_raise(exceptionInfo,"ERROR","fwDevice_getModel(): invalid device parameter:"+(string)device,"");
	    return;
	}

	if (!dpExists(device[fwDevice_DP_NAME])) {
	    fwException_raise(exceptionInfo,"ERROR","fwDevice_getModel(): non-existing device DP:"+device[fwDevice_DP_NAME],"");
	    return;
	}

	string dpe=device[fwDevice_DP_NAME]+".model";
	if (dpExists(dpe)) dpGet(dpe,model);

}


/** Returns the possible children datapoint types for a given device type and device
model (contained in the device object). The information is retrieved from a device
model definition.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device			device object
@param childrenDpTypes	list of possible children datapoint types for the given device type and model
@param exceptionInfo	details of any exceptions
*/
fwDevice_getModelChildrenDpTypes(dyn_string device, dyn_string &childrenDpTypes, dyn_string &exceptionInfo)
{
	dyn_string modelDp;

	childrenDpTypes = makeDynString();
	fwDevice_getModelDp(device, modelDp, exceptionInfo);
	//DebugN("fwDevice_getModelChildrenDpTypes(): modelDp = " + modelDp);
	if(dynlen(modelDp) == 3)
		dpGet(modelDp[1] + ".general.childrenDPTypes", childrenDpTypes);
}


/** Gets the datapoint used to contain information about the model of the given device.

@param device		device object. Either the device datapoint name or the device dp type and the model are required.
@param modelDp		on return will be filled with structure with the following information:
				<li> modelDp[1] = dp defining the model
				<li> modelDp[2] = model
@param exceptionInfo	details of any exceptions

Note that it is normal that a device has no model, in which case the information is in the device type definition.
In such case the modelDp is empty on return.

@reviewed 2018-10-03
*/
fwDevice_getModelDp(dyn_string device, dyn_string &modelDp, dyn_string &exceptionInfo)
{
	bool isLocal;
	string deviceDpType, deviceModel, key, sys;
	dyn_dyn_anytype dda;

//	DebugN("fwDevice_getModelDp(): device " + device);
	modelDp = makeDynString();

	if (device[fwDevice_DP_NAME] != "")
	{
//		DebugN("fwDevice_getModelDp(): not empty device dp name " + device);
		// FWCORE-3372: check if dp exists!
		if (!dpExists(device[fwDevice_DP_NAME])) {
		    fwException_raise(exceptionInfo,"ERROR","fwDevice_getModelDp(): specified device datapoint does not exist: "+device[fwDevice_DP_NAME],"");
		    return;
		}
		deviceDpType = 	dpTypeName(device[fwDevice_DP_NAME]);
		fwDevice_getModel(device, deviceModel, exceptionInfo);
		if (dynlen(exceptionInfo)) return;
		sys = dpSubStr(device[fwDevice_DP_NAME], DPSUB_SYS);
	}
	else
	{
		if((device[fwDevice_DP_TYPE] != "") && (device[fwDevice_MODEL] != ""))
		{
			deviceDpType = 	device[fwDevice_DP_TYPE];
			deviceModel = device[fwDevice_MODEL];
		}
		else
		{
			// don't force to have a model defined, so no exception here
//			DebugN("fwDevice_getModelDp(): modelDp: ." + modelDp + ". " + dynlen(modelDp));
			return;
		}
	}

	key = deviceDpType + "|" + deviceModel;
	if(sys == getSystemName() || sys == "")
	{
		isLocal = TRUE;
	}
	else
	{
		isLocal = FALSE;
	}

	// remove colon
	sys = substr(sys, 0, strpos(sys, ":"));
	//DebugN("fwDevice_getModelDp(): System = " + sys + " isLocal " + isLocal);

	// see if the dp is already in the cache, if not do a query
	// first try with local system, even if dp is in a remote system (no system included in key)
	if(mappingHasKey(fwDevice_modelDpCache, key))
	{
		modelDp = fwDevice_modelDpCache[key];
	}
	else // try with remote system
	{
		if(!isLocal)
		{
			key = sys + "|" + deviceDpType + "|" + deviceModel;
			if(mappingHasKey(fwDevice_modelDpCache, key))
			{
				modelDp = fwDevice_modelDpCache[key];
			}
		}
	}

	// model was not in cache, search for it
	if(modelDp == "")
	{
		if (deviceDpType=="") {
		    fwException_raise(exceptionInfo,"ERROR","fwDevice_getModelDp(): undetermined device type for "+(string)device,"");
		    return;
		}

		// search first in local system
		dpQuery("SELECT '.dpType:_online.._value', '.model:_online.._value'  FROM '*' WHERE _DPT = \"_FwDeviceModel\" AND '.dpType:_online.._value' == \"" +
				deviceDpType + "\" AND '.model:_online.._value' ==  \"" + deviceModel + "\"",
				dda);

		//DebugN("dda" + dda);
		// if no model definition was found search in the remote system
		if(dynlen(dda) == 1 && !isLocal)
		{
			dpQuery("SELECT '.dpType:_online.._value', '.model:_online.._value' FROM '*' REMOTE '" + sys + "' WHERE _DPT = \"_FwDeviceModel\" AND '.dpType:_online.._value' == \"" +
			deviceDpType + "\" AND '.model:_online.._value' ==  \"" + deviceModel + "\"",
			dda);
		}

		//DebugN(dda);
		// check if model definition was found either local or remote
		if(dynlen(dda) == 1)
		{
			// don't force to have a model defined, it could be using type definition. So no exception here
			return;
		}
		else
		{
			if(dynlen(dda) > 2)
			{
				fwException_raise(	exceptionInfo,
									"WARNING",
									"fwDevice_getModelDp(): found more than one dp with definition of model " + deviceModel + " for device type " + deviceDpType,
									"");
			}
			else
			{
				modelDp = dda[2];
				fwDevice_modelDpCache[key] = dda[2];
//				DebugN("fwDevice_getModelDp(): updating cache. Key = " + key + " " + " value = " + dda[2]);
			}
		}
	}
}

/** Returns all the information with the characteristics of a model of a given device type.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device			device object. Either the device datapoint name or the device dp type and the model are required.
@param modelProperties	information with the characteristics of the model:
						<ol>
							<li> Slots
							<li> Symbols
							<li> Units
							<li> Limits
							<li> Width
							<li> Children dp types
							<li> Name root
							<li> Name digits
							<li> Starting number
						</ol>
@param exceptionInfo	details of any exceptions
*/
fwDevice_getModelProperties(dyn_string device, dyn_dyn_string &modelProperties, dyn_string &exceptionInfo)
{
//	time t1, t2, t3, t4;
	int slots, nameDigits, startingNumber, width;
	string nameRoot;
	dyn_string modelDp, units, limits, childrenDpTypes, symbols;

//	t1 = getCurrentTime();

	fwDevice_getModelDp(device, modelDp, exceptionInfo);

	// if model could not be found, set some values by default
	if(dynlen(modelDp) != 3)
	{
		slots = 0;
		symbols = makeDynString();
		units =  makeDynString();
		limits =  makeDynString();
		width = 0;
		childrenDpTypes =  makeDynString();
		nameRoot = "";
		nameDigits = 0;
		startingNumber = 0;
	}
	else
	{
		dpGet(	modelDp[1] + ".slots", slots,
				modelDp[1] + ".symbols", symbols,
				modelDp[1] + ".units", units,
				modelDp[1] + ".limits", limits,
				modelDp[1] + ".width", width,
				modelDp[1] + ".general.childrenDPTypes", childrenDpTypes,
				modelDp[1] + ".general.nameRoot", nameRoot,
				modelDp[1] + ".general.nameDigits", nameDigits,
				modelDp[1] + ".general.startingNumber", startingNumber);
	}

	modelProperties = makeDynString();
	modelProperties[fwDevice_MODEL_SLOTS][1]			= slots;
	modelProperties[fwDevice_MODEL_SYMBOLS]				= symbols;
	modelProperties[fwDevice_MODEL_UNITS]				= units;
	modelProperties[fwDevice_MODEL_LIMITS]				= limits;
	modelProperties[fwDevice_MODEL_WIDTH][1]			= width;
	modelProperties[fwDevice_MODEL_CHILDREN_DP_TYPES]	= childrenDpTypes;
	modelProperties[fwDevice_MODEL_NAME_ROOT][1]		= nameRoot;
	modelProperties[fwDevice_MODEL_NAME_DIGITS][1]		= nameDigits;
	modelProperties[fwDevice_MODEL_STARTING_NUMBER][1]	= startingNumber;
//	DebugN("fwDevice_getModelProperties(): ", t4 - t3, t3 - t2, t2 - t1);
}


/** For a given device, returns the number of slots the device has.

@par Constraints
	Only supported for Framework devices that have a model defined

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device			device object. Either the device datapoint name or the device dp type and the model are required.
@param numberOfSlots	number of children devices the device can hold
@param exceptionInfo	details of any exceptions
*/
fwDevice_getModelSlots(dyn_string device, int &numberOfSlots, dyn_string &exceptionInfo)
{
	dyn_string modelDp;

	numberOfSlots = 0;

	fwDevice_getModelDp(device, modelDp, exceptionInfo);

	if(dynlen(modelDp) > 0)
		dpGet(modelDp[1] + ".slots", numberOfSlots);
}


/** Returns the number used to start the numbering of the children of a specific device

@par Constraints
	Only supported for Framework devices that have a model defined

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device			device object. Either the device datapoint name or the device dp type and the model are required.
@param startingNumber	number used to start the numbering
@param exceptionInfo	details of any exceptions
*/
fwDevice_getModelStartingNumber(dyn_string device, int &startingNumber, dyn_string &exceptionInfo)
{
	dyn_string modelDp;

	fwDevice_getModelDp(device, modelDp, exceptionInfo);
	if(dynlen(modelDp) != 3)
		return;
	dpGet(modelDp[1] + ".general.startingNumber", startingNumber);
}

/** Returns the symbols (reference panels) that can be used to represent the given device

@par Constraints
	Only supported for Framework devices that have a model defined

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device			device object. Either the device datapoint name or the device dp type and the model are required.
@param symbolFileNames	list of symbols (reference panels) that can be used to represent the device
@param exceptionInfo	details of any exceptions

@reviewed 2018-06-22 @whitelisted(API)
*/
fwDevice_getModelSymbols(dyn_string device, dyn_string &symbolFileNames, dyn_string &exceptionInfo)
{
	dyn_string modelDp;

	symbolFileNames = makeDynString();

	fwDevice_getModelDp(device, modelDp, exceptionInfo);

	if(dynlen(modelDp) > 0)
		dpGet(modelDp[1] + ".symbols", symbolFileNames);
}


/**Goes through the device dp name and returns the device name

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName		dp name of the device (e.g. CAEN/crate003/board07/channel005)
@param deviceName		returned name of the device (e.g. channel005)
@param exceptionInfo	details of any exceptions
*/
fwDevice_getName(string deviceDpName, string &deviceName, dyn_string &exceptionInfo)
{
	dyn_string aux;

	deviceName = "";
	if(deviceDpName == "")
		return;

	// remove system name
	deviceDpName = substr(deviceDpName, strpos(deviceDpName, ":") + 1);

	aux = strsplit(deviceDpName, fwDevice_HIERARCHY_SEPARATOR);
	deviceName = aux[dynlen(aux)];
}


/** Returns all the panels to be used for a given device.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device			device object. It has to contain the device dp name, the device dp type, or the device dp type
						and the	device dp model if one wants to include model specific characteristics.
@param panels			returns all the panels for the specified device. Each row of the matrix contains
				the list of panels of one type. To access the matrix the constants of the form
				fwDevice_PANEL_XXXXX_XXXXX have to be used. For example, panels[fwDevice_PANELS_HARDWARE_OPERATION]
				will return the list of operation panels of the device in the hardware hierarchy.
						The constants are:
							<li>fwDevice_PANEL_NAVIGATOR_HARDWARE
							<li>fwDevice_PANEL_NAVIGATOR_LOGICAL
							<li>fwDevice_PANEL_EDITOR_HARDWARE
							<li>fwDevice_PANEL_EDITOR_LOGICAL
							<li>fwDevice_PANEL_EDITOR_EXPERT
							<li>fwDevice_PANEL_EDITOR_HARDWARE_ADD
							<li>fwDevice_PANEL_EDITOR_HARDWARE_REMOVE
@param exceptionInfo	details of any exceptions
*/
fwDevice_getPanels(dyn_string device, dyn_dyn_string &panels, dyn_string &exceptionInfo)
{
	string definitionDp;

	fwDevice_getDefinitionDp(device, definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(	definitionDp + ".panels.navigator.hardware", panels[fwDevice_PANEL_NAVIGATOR_HARDWARE],
			definitionDp + ".panels.navigator.logical", panels[fwDevice_PANEL_NAVIGATOR_LOGICAL],
			definitionDp + ".panels.editor.hardware", panels[fwDevice_PANEL_EDITOR_HARDWARE],
			definitionDp + ".panels.editor.logical", panels[fwDevice_PANEL_EDITOR_LOGICAL],
			definitionDp + ".panels.editor.expert", panels[fwDevice_PANEL_EDITOR_EXPERT],
			definitionDp + ".panels.editor.hardwareAdd", panels[fwDevice_PANEL_EDITOR_HARDWARE_ADD],
			definitionDp + ".panels.editor.hardwareRemove", panels[fwDevice_PANEL_EDITOR_HARDWARE_REMOVE]);
}


/** Returns the device datapoint name of the parent device.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName		dp name of the device (e.g. CAEN/crate003/board07/channel005)
@param deviceDpParent	returns the dp name of the parent device (e.g. CAEN/crate003/board07)
@param exceptionInfo	details of any exceptions
*/
fwDevice_getParent(string deviceDpName, string &deviceDpParent, dyn_string &exceptionInfo)
{
	int i, pos;
	string posDpName = deviceDpName, aux, aux2, posString;
	dyn_string dsAux;

	deviceDpParent = "";
	dsAux = strsplit(deviceDpName, fwDevice_HIERARCHY_SEPARATOR);
	if(dynlen(dsAux) > 1)
	{
		deviceDpParent = substr(deviceDpName, 0, strlen(deviceDpName) - strlen(fwDevice_HIERARCHY_SEPARATOR + dsAux[dynlen(dsAux)]));
	}
}


/** Goes through the device dp name and returns the device name without
any trailing number and the position if the dp name ends in an integer number.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName		dp name of the device (e.g. CAEN/crate003/board07/channel005)
@param name				returns root name of the device (e.g. channel)
@param position		position of the device coded in the name (e.g. 5), or -1 if no position could be found
@param exceptionInfo	details of any exceptions
*/
fwDevice_getPosition(string deviceDpName, string &name, int &position, dyn_string &exceptionInfo)
{
	int result, initLen, len;
	string deviceName, sString, sNumeric;

	// initialize returned variables
	name = "";

	// get device name
	fwDevice_getName(deviceDpName, deviceName, exceptionInfo);
	initLen = strlen(deviceName);

	// split device name in: name + position
	do
	{
		// accumulate numeric part in name
		name = name + sNumeric;

		// reset loop variables
		sNumeric = "";
		sString = "";

		// parse to find a string + a number
		result = sscanf(deviceName, "%[^0-9]%[0-9]", sString, sNumeric);

		// accummulate string part in name
		name = name + sString;

//		DebugN(deviceName, sName, sPos, name);

		// remove from deviceName what was already found
		deviceName = substr(deviceName, strlen(sString + sNumeric));
	}
	while(strlen(name + sNumeric) != initLen);

	// assign position only if it was found as last part of the device name
	if(sNumeric == "")
		position = -1;
	else
		position = (int)sNumeric;
}

/** Returns a list with the possible address types for a device or device model

The function return a list of address types that a device or device model could have,
based on the information in the device definition, and depending on parameters that
are passed.

In the default variant, one would pass a datapoint type name in the deviceDpType parameter,
and the function will look up the matching device definition for it and find the matching
addresses.
One may also use the deviceModel optional parameter to query the information for a particular
model for the specifed deviceDpType. Note that for some device types model information
is declared for completness, yet the ".modelDefinition.useModelDefinition" may be set to false
hence effectively disabling the retrieval of the model. In such case, the information
from non-specific device definition will be retrieved.

In the second variant, one would use the deviceDpName to specify an existing device,
for which the information should be queried. The device may be from the local or from any
connected dist system. The model name of the actual device is retrieved and then used for
further query. Note that (this is historical compatibility option!) for remote devices
the device definition of LOCAL SYSTEM is firstly queried, and only if it is not find then
it is queried from the remote system. In this mode, the parameters deviceDpType and
deviceModel are ignored.

@reviewed 2018-08-14, Implementation changed to use dpQuery, documentation extended.

@param deviceDpType	device datapoint type (e.g. "FwCaenBoardSY1527"); ignored if deviceDpName specified
@param addressTypes	on return will contain the list of possible address types
@param exceptionInfo	standard exception handling variable
@param deviceModel	(optional) device model (e.g. "AG536S"); ignored if deviceDpName specified
@param deviceDpName	(optional) datapoint name of the device, if information is queried for
                        an existing device rather that for device type (see description above).
*/
fwDevice_getPossibleAddressTypes( string deviceDpType, dyn_string &addressTypes, dyn_string &exceptionInfo,
                                  string deviceModel = "", string deviceDpName = "")
{
	string definitionDp;
	dynClear(addressTypes);

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "") {
	    // note that the fwDevice_getDefinitionDp does not throw an exception on not-existing DPs, etc.
	    // However, here we need to throw it (FWCORE-3363)
	    if (deviceDpName!="") {
		if (!dpExists(deviceDpName)) {
		    fwException_raise(exceptionInfo,"ERROR","Cannot get possible address types for "+deviceDpName+" DP does not exist.","");
		} else {
		    fwException_raise(exceptionInfo,"ERROR","Cannot get possible address types for "+deviceDpName,"");
		}
	    } else if (!fwGeneral_dpTypeExists(deviceDpType)) {
		fwException_raise(exceptionInfo,"ERROR","Cannot get possible address types - dptype "+deviceDpType+" does not exist","");
	    } else {
		fwException_raise(exceptionInfo,"ERROR","Cannot get possible address types - dptype "+deviceDpType+" has no device definition","");
	    }
	}
	if (dynlen(exceptionInfo)) return;

	// we want to query all the possible elements of the model dp such as "FwAiInfo.configuration.address.<ADDRTYPE>.general.canHave"
	// For this, we could use the dpQuery and be future-proof for extensions of device definition (FWCORE-3362)
	// Note that if we work with specific models, the definitionDp will return a string being the datapoint plus
	// appropriate DPE prefix for ".modelDefinition.definition" ready to use in construction of a query,
	// eg. "dist_1:FwCaenBoardSY1527ModelAG536S.modelDefinition.definition"

	dyn_dyn_mixed data;
	// construct the query
	string query="SELECT '_original.._value' FROM '"+definitionDp+".configuration.address.**.canHave' ";"WHERE '_original.._value' = \"TRUE\"";
	// check if we need to have a remote query...
	int pos=strpos(definitionDp,":");
	if (pos>0) {
	    string sysName=strrtrim(dpSubStr(definitionDp,DPSUB_SYS),":");
	    query += " REMOTE '" + sysName + "' ";
	}
	query+= " WHERE '_original.._value' = \"TRUE\"";

	int rc = dpQuery(query,data);
	if (rc) {
	    dyn_errClass err=getLastError();
	    fwException_raise(exceptionInfo,"ERROR","Cannot get possible address types for "+deviceDpType+" : query failed (see log)","");
	    DebugTN(__FUNCTION__,"Failed dpQuery",query,getErrorText(err));
	    return;
	}

	// parse the results, and extract the address type name from the returned DPE Name
	// e.g. from dist_1:FwAiInfo.configuration.address.MODBUS.general.canHave we want to extract "MODBUS"
	// the same may apply for DeviceModel, hence we iterate from the back
	for (int i=1;i<=dynlen(data);i++) {
	    string dpe=data[i][1];
	    dyn_string ds=strsplit(dpe,".");
	    if (dynlen(ds)>3) {
		string addrType=ds[dynlen(ds)-2];
		dynAppend(addressTypes,addrType);
	    }
	}
}

/** Returns default address type for specified device model or device instance

See the documentation of @ref fwDevice_getPossibleAddressTypes for explanation of the
modes of operation.

@param deviceDpType	device datapoint type (e.g. "FwCaenBoardSY1527"); ignored if deviceDpName specified
@param exceptionInfo	standard exception handling variable
@param deviceModel	(optional) device model (e.g. "AG536S"); ignored if deviceDpName specified
@param deviceDpName	(optional) datapoint name of the device, if information is queried for
                        an existing device rather that for device type.
@param excOnUndefined (optional) if set (default) exception will be generated in the case when the default
                        address type is empty; otherwise it will simply return with an empty string and
                        empty @c exceptionInfo;

*/
string fwDevice_getDefaultAddressType( string deviceDpType, dyn_string &exceptionInfo, string deviceModel = "", string deviceDpName = "", bool excOnUndefined=true)
{
    string definitionDp;
    string addressType="";
    fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
    if(definitionDp == "") {
	// note that the fwDevice_getDefinitionDp does not throw an exception on not-existing DPs, etc.
	// However, here we need to throw it (FWCORE-3363)
	if (deviceDpName!="") {
	    if (!dpExists(deviceDpName)) {
		fwException_raise(exceptionInfo,"ERROR","Cannot get default address type for "+deviceDpName+" DP does not exist.","");
	    } else {
		fwException_raise(exceptionInfo,"ERROR","Cannot get default address types for "+deviceDpName,"");
	    }
	} else if (!fwGeneral_dpTypeExists(deviceDpType)) {
	    fwException_raise(exceptionInfo,"ERROR","Cannot get default address type for - dptype "+deviceDpType+" does not exist","");
	} else {
	    fwException_raise(exceptionInfo,"ERROR","Cannot get default address type - dptype "+deviceDpType+" has no device definition","");
	}
    }
    if (dynlen(exceptionInfo)) return "";

    // Note that if we work with specific models, the definitionDp will return a string being the datapoint plus
    // appropriate DPE prefix for ".modelDefinition.definition" ready to use in construction of a query,
    // eg. "dist_1:FwCaenBoardSY1527ModelAG536S.modelDefinition.definition"

    int rc=dpGet(definitionDp+".configuration.address.general.defaultType",addressType);
    if (rc) {
	fwException_raise(exceptionInfo,"ERROR","Cannot get default address type from device definition "+definitionDp,"");
	return "";
    }

    if (addressType=="") {
		if (excOnUndefined) {
			fwException_raise(exceptionInfo,"ERROR","Default address type is undefined in Device Definition "+definitionDp,"");
		}
		return "";
    }

    return addressType;
}

/** Gets the possible combinations dp type - model that a device can have as children.
It is a combination of all the information available in the _FwDeviceDefinition and
_FwDeviceModel datapoints. For that several functions are used:

	<li>fwDevice_getModelChildrenDpTypes (gets the possible children for the model)
	<li>fwDevice_getPossibleDpTypes (gets the possible children for the dp type).

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device						device object (dp type and model, or dp name are required)
@param childrenDpTypesAndModels 	matrix containing list of possible children dp type - models:
									<li>childrenDpTypesAndModels[x][1] = device dp type
									<li>childrenDpTypesAndModels[x][2] = device model 1 of the above device dp type
									<li>childrenDpTypesAndModels[x][3] = device model 2 of the above device dp type
									<li>...
									<li>childrenDpTypesAndModels[x][n] = device model n - 1 of the above device dp type
@param exceptionInfo				details of any exceptions
*/
fwDevice_getPossibleChildren(dyn_string device, dyn_dyn_string &childrenDpTypesAndModels, dyn_string &exceptionInfo)
{
	int i, j, index, count = 1;
	dyn_string modelDp, childrenDPTModels, childrenDpTypes, ds, models;
	dyn_dyn_string childrenDpTypesAndModelsTemp;

	childrenDpTypesAndModels = makeDynString();

	fwDevice_getModelDp(device, modelDp, exceptionInfo);

	if(dynlen(modelDp) == 3)
		dpGet(modelDp[1] + ".general.childrenDPTModels", childrenDPTModels);

	for(i = 1; i <= dynlen(childrenDPTModels); i++)
	{
		fwGeneral_stringToDynString(childrenDPTModels[i], ds, "|", false);
		childrenDpTypesAndModelsTemp[count++] = ds;
	}

	fwDevice_getChildrenDpTypes(device, childrenDpTypes, exceptionInfo);
	if(dynlen(childrenDpTypes) == 0)
	{
		fwDevice_fillDpType(device, exceptionInfo);
		if(device[fwDevice_DP_TYPE] == "FwNode" && device[fwDevice_DP_NAME] != "")
		{
			dpGet(device[fwDevice_DP_NAME] + ".dpTypes", childrenDpTypes);
		}
	}

	// try to get models specifying parent
	for(i = 1; i <= dynlen(childrenDpTypes); i++)
	{
		fwDevice_getTypeModels(childrenDpTypes[i], device[fwDevice_DP_NAME], models, exceptionInfo, device[fwDevice_MODEL]);
		for(j = 1; j <= dynlen(models); j++)
		{
			childrenDpTypesAndModelsTemp[count++] = makeDynString(childrenDpTypes[i], models[j]);
		}
	}

	// if there were no models explicitly defined or with a specific parent, try without specifying a parent
	if(dynlen(childrenDpTypesAndModelsTemp) == 0)
	{
		for(i = 1; i <= dynlen(childrenDpTypes); i++)
		{
			fwDevice_getTypeModels(childrenDpTypes[i], "", models, exceptionInfo);
			if(dynlen(models) > 0)
			{
				for(j = 1; j <= dynlen(models); j++)
				{
					childrenDpTypesAndModelsTemp[count++] = makeDynString(childrenDpTypes[i], models[j]);
				}
			}
			else
			{
				childrenDpTypesAndModelsTemp[count++] = makeDynString(childrenDpTypes[i], "");
			}
		}
	}

	count = 1;
	// process to have one row per device type
	for(i = 1; i <= dynlen(childrenDpTypesAndModelsTemp); i++)
	{
		ds = getDynString(childrenDpTypesAndModels, 1);

		index = dynContains(ds, childrenDpTypesAndModelsTemp[i][1]);
		if(index > 0)
			dynAppend(childrenDpTypesAndModels[index], childrenDpTypesAndModelsTemp[i][2]);
		else
			childrenDpTypesAndModels[count++] = childrenDpTypesAndModelsTemp[i];
	}

//	DebugN("fwDevice_getPossibleChildren() ", device, childrenDpTypesAndModels, childrenDpTypesAndModelsTemp);
}


/** Returns which dp types can be used as children of the
specified dp type

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		device datapoint type (e.g. FwCaenBoard)
@param childrenDpTypes	list of possible children dp types
@param exceptionInfo	details of any exceptions
*/
fwDevice_getPossibleChildrenDpTypes(string deviceDpType, dyn_string &childrenDpTypes, dyn_string &exceptionInfo)
{
	childrenDpTypes = makeDynString();
	dpGet(deviceDpType + fwDevice_DEFINITION_SUFIX + ".general.childrenDPTypes", childrenDpTypes);
}


/** For a given device type and device model, returns its datapoint elements
that can have a pv_range config, based on the device definition.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param elements			elements that can have pv range
@param exceptionInfo	details of any exceptions
@param deviceModel		model of the device (e.g. A834P)
*/
fwDevice_getPvRangeElements(string deviceDpType, dyn_string &elements, dyn_string &exceptionInfo, string deviceModel = "")
{
	dyn_dyn_string elementsAndProperties;

	fwDevice_getConfigElements(deviceDpType, fwDevice_PVRANGE_INDEX, elementsAndProperties, exceptionInfo, deviceModel);
	elements = elementsAndProperties[1];
}


/** Returns the dp elements in a device type (e.g. FwCaenBoard) that are of the selected
data type (e.g FLOAT, REFERENCE). This is based in the device definition, and not in the
PVSS datapoint element type.

@par Constraints
	None

@par Usage
	JCOP Framework internal

@par PVSS managers
	VISION, CTRL

@param deviceDpType		device datapoint type (e.g. FwCaenBoard)
@param selectedType		required data type for the dpes. The possible types are:
							<li>fwDevice_DPE_TYPE_REFERENCE
							<li>fwDevice_DPE_TYPE_INT
							<li>fwDevice_DPE_TYPE_FLOAT
							<li>fwDevice_DPE_TYPE_BOOL
							<li>fwDevice_DPE_TYPE_STRING
@param elements			elements with the required data type
@param exceptionInfo	details of any exceptions
@param deviceModel		device model (e.g. A834P)
@param deviceDpName		dp name of the device. This is required when we want this function to retrieve the panels for a device
						that is not installed locally but we still want to be able to browse instances in a remote system.
						If the device definition is available locally, then it will be used even if we browse a remote system.
*/
fwDevice_getElementsOfType(	string deviceDpType, string selectedType, dyn_string &elements, dyn_string &exceptionInfo,
							string deviceModel = "", string deviceDpName = "")
{
	string definitionDp;
	dyn_string dpes, dpeTypes;

	fwDevice_getDefinitionDp(makeDynString(deviceDpName, deviceDpType, "", deviceModel), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	dpGet(	definitionDp + fwDevice_ELEMENTS, 		dpes,
			definitionDp + fwDevice_ELEMENTS_TYPES,	dpeTypes);

	// initialize return value
	elements = makeDynString();

	// find dpes of selected type
	for(int i = 1; i <= dynlen(dpeTypes); i++)
	{
		if(strtoupper(dpeTypes[i]) == strtoupper(selectedType))
			dynAppend(elements, dpes[i]);
	}
}


/** For a given device type and device model, returns its datapoint elements
that can have a smooth config, based on the device definition.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		datapoint type of the device (e.g. FwCaenBoard)
@param elements			elements that can have smoothing
@param exceptionInfo	details of any exceptions
@param deviceModel		model of the device (e.g. A834P)
*/
fwDevice_getSmoothingElements(string deviceDpType, dyn_string &elements, dyn_string &exceptionInfo, string deviceModel = "")
{
	dyn_dyn_string elementsAndProperties;

	fwDevice_getConfigElements(deviceDpType, fwDevice_SMOOTHING_INDEX, elementsAndProperties, exceptionInfo, deviceModel);
	elements = elementsAndProperties[1];
}


/** Gets the device type associated with the given device datapoint type.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		device datapoint type (e.g. FwCaenBoard)
@param deviceType		device type associated to deviceDpType
@param exceptionInfo	details of any exceptions
*/
fwDevice_getType(string deviceDpType, string &deviceType, dyn_string &exceptionInfo)
{
	bool exists;
	unsigned dpId;
	int elId;

	deviceType = "";
	exists = dpGetId (deviceDpType + fwDevice_DEFINITION_SUFIX + ".type", dpId, elId);

	if(exists)
		dpGet(deviceDpType + fwDevice_DEFINITION_SUFIX + ".type", deviceType);
}


/** Returns a list of possible device models for a given device datapoint type.
Optionally, it is possible to restrict the search to possible models, when the
type it is used as child of a given device type/model.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpType		device datapoint type (e.g. FwCaenBoard)
@param parentDpName		defines parent device type/model to restrict search
@param models			returns all models of the device type
@param exceptionInfo	details of any exceptions
@param parentModel		optional model of the parent (e.g. SY527)
*/
fwDevice_getTypeModels(string deviceDpType, string parentDpName, dyn_string &models, dyn_string &exceptionInfo, string parentModel = "")
{
	int i;
	string selectedParentModel, model, dpType, parentModelGet;
	dyn_string allModels;
	dyn_dyn_anytype dda;

	// all dps defining models for the type start with the device type
	allModels = dpNames(deviceDpType + "*", "_FwDeviceModel");
	if(parentModel != "")
	{
		selectedParentModel = parentModel;
	}
	else
	{
		if(parentDpName != "") {
			fwDevice_getModel(makeDynString(parentDpName), selectedParentModel, exceptionInfo);
			if (dynlen(exceptionInfo)) return;
		}
	}
	models = makeDynString();

	//DebugN(selectedParentModel);

	/*dpQuery("SELECT '.dpType:_online.._value', '.model:_online.._value' FROM '*' WHERE _DPT = \"_FwDeviceModel\" AND '.dpType:_online.._value' == \"" +
			deviceDpType + "\"", dda);

	DebugN("Query result:");
	DebugN(dda);

	for(i = 2; i <= dynlen(dda); i++)
	{
		models[i - 1] = dda[i][2];
		//DebugN(dda[i]);
	}*/

	// go through all the models to identify which ones correspond to the selected
	// dp type and parent model
	for(i = 1; i <= dynlen(allModels); i++)
	{
		dpGet(	allModels[i] + ".parentModel", parentModelGet,
				allModels[i] + ".dpType", dpType);
		//DebugN("parentModel " + parentModel + " dpType " + dpType);
		if(dpType == deviceDpType)
		{
			if((parentModelGet == selectedParentModel) || (selectedParentModel == ""))
			{
				dpGet(allModels[i] + ".model", model);
				dynAppend(models, model);
			}
		}
	}
}


/** Opens the panel to add children devices to the specified device. This
can be the default panel or a customized panel entered in the device definition.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	graphics manager

@param device			device to add children to
@param fReturn			for future use
@param sReturn			for future use
@param exceptionInfo	details of any exceptions
*/
fwDevice_openPanelAdd(dyn_string device, dyn_float &fReturn, dyn_string &sReturn, dyn_string &exceptionInfo)
{
	string panel;
	dyn_string panels;

	fwDevice_getPanels(device, panels, exceptionInfo);

//	DebugN("panels " + panels);
	if(panels[fwDevice_PANEL_EDITOR_HARDWARE_ADD] == "")
		panel = fwDevice_PANEL_EDITOR_HARDWARE_ADD_DEFAULT;
	else
		panel = panels[fwDevice_PANEL_EDITOR_HARDWARE_ADD];

	ChildPanelOnCentralModalReturn(	panel + ".pnl",
										"Add Device",
										makeDynString("$sDpName:" + device[fwDevice_DP_NAME]),
										fReturn, sReturn);
}


/**
  This function is used to process a template string for an address with the help of replacement
  variables. The expressions to be evaluated must be enclosed in two curly brackets {{expr}}. It
  is possible to have several expressions in the string passed, but they cannot be nested.

  @param stringToEvaluate string with expressions to be evaluated
  @param variables mapping of variable names to variable values
  @param exceptionInfo details of any exception
  @return evaluated expression
*/
string fwDevice_evalExpression(string stringToEvaluate, mapping variables, dyn_string& exceptionInfo) {

	if (strpos(stringToEvaluate, "{{") == -1)
		return stringToEvaluate;

	if (mappingHasKey(variables, "dpname"))
	{
		mapping defaults = fwDevice_getReplacementsFromDp(variables["dpname"], exceptionInfo);
		string key;

 		for (int i=1; i <= mappinglen(defaults); i++)
 		{
        	key= mappingGetKey(defaults, i);
        	if (! mappingHasKey(variables, key))
			{
 				variables[key] = defaults[key];
			}
		}
	}

	int res;
	string originalStringToEvaluate;
	string retVal;
	string script = "";
	string var;

	originalStringToEvaluate = stringToEvaluate;

//	strreplace(stringToEvaluate, "\"", "\\\"" );

	stringToEvaluate = "\"" + stringToEvaluate + "\"";
	strreplace(stringToEvaluate, "{{", "\"+((string) (" );
	strreplace(stringToEvaluate, "}}", "))+\"" );

	for (int i = 1; i <= mappinglen(variables); i++)
	{
		var = mappingGetKey(variables, i);
		script = script + " anytype " + var + "=m[\"" + var + "\"]; ";
	}

	script = "string main(mapping m, string originalStringToEvaluate ) { " + script + "\n try { return  ( " + stringToEvaluate + "); } catch {  DebugN(\"Error in evaluation of \", originalStringToEvaluate); return originalStringToEvaluate; } \n}";

	DebugFTN("FW_INFO", "fwDevice_evalExpression(): ", script, originalStringToEvaluate, stringToEvaluate);

	res = evalScript(retVal, script, makeDynString(), variables, originalStringToEvaluate);
	if (res == -1)
	{
		DebugFTN("FW_ERROR", "Error evaluating script ", script);
		fwException_raise(exceptionInfo, "EVAL_ERROR",
											"fwDevice_evalExpression: Error in evaluating expressions " + originalStringToEvaluate , "");
		return "";
	}

  return retVal;
}

/** This function is used to process a template string for an address,
replacing the tokens by their value. The tokens have to be appended by
a number to indicate a position in the hierarchy. The numbering starts
with 1 referencing the current device, 2 referencing the parent and so
on. The possible tokens are:

	<li>dpName: references a device dp name (e.g. \%dpName1% references the
			current device dp name)
	<li>name: references a device name (e.g. \%name2% references the device
			name of the parent of the current device)
	<li>pos: references the position of the device. The position is taken
			from the dp name and treated as a string, so, for example, it
			may contain	trailing zeros (e.g. \%pos2% references the position
			of the parent device in the grandparent).
	<li>decPos: references the position of the device. The position is taken
			from the dp name and treated as an int (e.g. \%decPos2% references
			the position of the parent device in the grandparent).

@par Constraints
	None

@par Usage
	JCOP Framework internal

@par PVSS managers
	VISION, CTRL

@param deviceDpName		device to which the template belongs (e.g. CAEN/crate003/board07/channel005)
@param templateString	template to be processed
@param finalString		result of the processing
@param exceptionInfo	details of any exceptions
@param deviceHierarchy	optionally it is possible to pass the hierarchy as returned by fwDevice_getHierarchy, to speed up
*/
fwDevice_processAddressTemplate(	string deviceDpName, string templateString,
									string &finalString, dyn_string &exceptionInfo, dyn_dyn_string deviceHierarchy = "", mapping replacements = fwDevice_emptyMap)
{
//	time t1, t2, t3, t4, t5;
	int i, pos, openingPos, closingPos, value, result;
	string name, expression, evalExpression, sValue;
	string	fwDevice_ADDRESS_TEMPLATE_EXPRESSION_OPENING_TAG = "{",
			fwDevice_ADDRESS_TEMPLATE_EXPRESSION_CLOSING_TAG = "}";
	dyn_dyn_string modelProperties;


//	t1 = getCurrentTime();

	// if the device hierarchy was not passed, then get it
	if(deviceHierarchy == "")
	{
		fwDevice_getHierarchy(deviceDpName, deviceHierarchy, exceptionInfo);
	}

//	t2 = getCurrentTime();
//	DebugN("templateString", templateString);

	// substitute tokens by their value
	for(i = 1; i <= dynlen(deviceHierarchy); i++)
	{
		fwDevice_getName(deviceHierarchy[i][1], name, exceptionInfo);
		strreplace(templateString, "%dpName" + i + "%", deviceHierarchy[i][1]);
		strreplace(templateString, "%name" + i + "%", name);
		strreplace(templateString, "%pos" + i + "%", deviceHierarchy[i][2]);
		strreplace(templateString, "%decPos" + i + "%", deviceHierarchy[i][3]);

	}
 replacements["dpname"] = deviceDpName;
 replacements["deviceHierarchy"] = deviceHierarchy;

//	t3 = getCurrentTime();
	fwDevice_getModelProperties(makeDynString(deviceDpName), modelProperties, exceptionInfo);

 // Process the double brackets with the replacements
 templateString = fwDevice_evalExpression(templateString, replacements, exceptionInfo);

//	t4 = getCurrentTime();
	// evaluate expressions
	while(TRUE)
	{
		openingPos = strpos(templateString, fwDevice_ADDRESS_TEMPLATE_EXPRESSION_OPENING_TAG);
		closingPos = strpos(templateString, fwDevice_ADDRESS_TEMPLATE_EXPRESSION_CLOSING_TAG);

		if((openingPos < 0) || (closingPos < 0))
			break;

		expression = substr(templateString, openingPos, closingPos - openingPos + 1);
		evalExpression = strrtrim(expression, fwDevice_ADDRESS_TEMPLATE_EXPRESSION_CLOSING_TAG);
		evalExpression = strltrim(evalExpression, fwDevice_ADDRESS_TEMPLATE_EXPRESSION_OPENING_TAG);

//		DebugN("evalExpression " + evalExpression);
		result = evalScript(value, "int main() { return " + evalExpression + ";}", makeDynString());
		if (result < 0)
		{

			fwException_raise(	exceptionInfo,
								"ERROR",
								"fwDevice_processAddressTemplate(): there were problems evaluating the template " + templateString + " for device " + deviceDpName,
								"");
		}

		// consider same number of digits as device name had originally.
		// this is only for the device itself, not the parent hierarchy
		if(dynlen(modelProperties) > 0)
		{
			sprintf(sValue, "%0" + 	modelProperties[fwDevice_MODEL_NAME_DIGITS][1] + "d", value);
		}
		else
		{
			sValue = value;
		}

		strreplace(templateString, expression, sValue);

//		DebugN("Value = " + value);
//		DebugN("exceptionInfo " + exceptionInfo);
//		DebugN(openingPos, closingPos, expression);
	}
//	t5 = getCurrentTime();
	finalString = templateString;

//	DebugN("fwDevice_processAddressTemplate(): ", t5 - t4, t4 - t3, t3 - t2, t2 - t1);
//	DebugN("modelProperties", modelProperties);
//	DebugN("finalString", finalString);
}


/** Sets the alias of the device and all its logical children to
an empty string (""), so that they are removed from the logical
hierarchy.

@par Constraints
	Only local because of limitation of dpAliasToName

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device			device object. Only device DP alias is required.
@param exceptionInfo	details of any exceptions
*/
fwDevice_removeAliasRecursively(dyn_string device, dyn_string &exceptionInfo)
{
	dyn_string children;

	fwDevice_getChildren(device[fwDevice_DP_ALIAS], fwDevice_LOGICAL, children, exceptionInfo);

	for(int i = 1; i <= dynlen(children); i++)
	{
		fwDevice_removeAliasRecursively(makeDynString("", "", "", "", children[i]), exceptionInfo);
	}

	device[fwDevice_DP_NAME] = strrtrim(dpAliasToName(device[fwDevice_DP_ALIAS]), ".");
	device[fwDevice_DP_TYPE] = dpTypeName(device[fwDevice_DP_NAME]);

	//DebugN(device);

	// Nodes are special because they are really deleted from the system
	if(device[fwDevice_DP_TYPE] == "FwNode")
	{
		// if it is a node it is not needed anymore, so we delete it
		dpDelete(device[fwDevice_DP_NAME]);
	}
	else
	{
		// if it is not a node just remove the alias
		dpSetAlias(device[fwDevice_DP_NAME] + ".", "");
	}
}


/** Renames the device in the logical view (sets the device alias to the
new value) and consequently changes all its logical children so that the
hierarchy is preserved. It is important to stress that what is changed is
the device alias (e.g. wire001, and not the device dp alias (e.g.
chamber03/plane02/wire001), so the device stays in the same position in the
logical hierarchy. To move a device in the logical hierarchy, one has to
use the copy/paste features of the Device Editor and Navigator.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param device			device object. Only device DP alias is required.
@param newDeviceAlias	new device alias for the device
@param exceptionInfo	details of any exceptions
*/
fwDevice_renameLogical(dyn_string device, string newDeviceAlias, dyn_string &exceptionInfo)
{
	string parentDeviceDpAlias, newDeviceDpAlias, currentDeviceDpAlias;
	dyn_string children;

	// derive new dp alias for device
	fwDevice_getParent(device[fwDevice_DP_ALIAS], parentDeviceDpAlias, exceptionInfo);

	if(parentDeviceDpAlias != "")
		newDeviceDpAlias = parentDeviceDpAlias + fwDevice_HIERARCHY_SEPARATOR + newDeviceAlias;
	else
		newDeviceDpAlias = newDeviceAlias;

	fwGeneral_getNameWithoutSN(newDeviceDpAlias, newDeviceDpAlias, exceptionInfo);
 fwGeneral_getNameWithoutSN(device[fwDevice_DP_ALIAS], currentDeviceDpAlias, exceptionInfo);

 if (currentDeviceDpAlias == newDeviceDpAlias) {
   fwException_raise(exceptionInfo, "ERROR", "fwDevice_renameLogical(): Alias is already " + newDeviceDpAlias, "");
   return;
 }

 if (strlen(dpAliasToName(newDeviceDpAlias)) > 0) {
   fwException_raise(exceptionInfo, "ERROR", "fwDevice_renameLogical(): Alias " + newDeviceDpAlias + " already exists", "");
   return;
 }

	fwDevice_getChildren(device[fwDevice_DP_ALIAS], fwDevice_LOGICAL, children, exceptionInfo);

	// set new parent device dp alias for all the children
	for(int i = 1; i <= dynlen(children); i++)
	{
		fwDevice_deleteLogical(makeDynString("", "", "", "", children[i]), newDeviceDpAlias, exceptionInfo);
	}

	device[fwDevice_DP_NAME] = strrtrim(dpAliasToName(device[fwDevice_DP_ALIAS]), ".");
	dpSetAlias(device[fwDevice_DP_NAME] + ".", newDeviceDpAlias);
}


/** Sets the address for the given device with the given parameters.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName			dp name of the device (e.g. CAEN/crate003/board07/channel005)
@param addressParameters	parameters to be used when setting the address
@param exceptionInfo		details of any exceptions
@param itemPrefix			prefix to be used for all the item names in the addresses
@param dpes					list of dpes to consider, if empty all dpes are considered
@param replacements mapping of the replacments to pass to generate the dp function from template. If empty it is filled automatically based on the default values
*/
fwDevice_setAddress(string deviceDpName, dyn_string addressParameters, dyn_string &exceptionInfo, string itemPrefix = "", dyn_string dpes = makeDynString(""), mapping replacements = fwDevice_emptyMap)
{
//	time t1, t2, t3, t4, t5, t6, t7, t8, tn, dt;
	bool hasAddress, withSelectedDpes;
	int driverNumber, objectSize;
	string	definitionDp, deviceModel;
	dyn_bool canHaveDpFunction;
	dyn_int addressModes;
	dyn_string dpElements, items, dpFunctions, dpParams, dpParamsList, device, elementsToDelete;
	dyn_dyn_string deviceHierarchy;

	//	t1 = getCurrentTime();
	DebugFTN("FW_INFO", "fwDevice_setAddress(" + deviceDpName + ")", dpes);
	if(!dpExists(deviceDpName))
	{
		fwException_raise(	exceptionInfo,
							"ERROR",
							"fwDevice_setAddress(): " + deviceDpName + " does not exist",
							"");
		return;
	}

	// create device object
	device = makeDynString(deviceDpName, dpTypeName(deviceDpName), "", "");

	// fill in model information
	fwDevice_getModel(device, deviceModel, exceptionInfo);
	if (dynlen(exceptionInfo)) return;
	device[fwDevice_MODEL] = deviceModel;

	fwDevice_getDefinitionDp(device, definitionDp, exceptionInfo);
	if (dynlen(exceptionInfo)) return;
	if(definitionDp == "")
		return;

	// read default address if asked for it
	if(addressParameters[fwDevice_ADDRESS_TYPE] == fwDevice_ADDRESS_DEFAULT) {
		fwDevice_getAddressDefaultParams(device[fwDevice_DP_TYPE], addressParameters, exceptionInfo, deviceModel);
		if (dynlen(exceptionInfo)) return;

	}
	DebugFTN("FW_INFO", "fwDevice_setAddress(): device " + device);
	DebugFTN("FW_INFO", "fwDevice_setAddress(): addressParameters " + addressParameters);
	DebugFTN("FW_INFO", "fwDevice_setAddress(): definitionDp ", definitionDp);

	// get the device hierarchy to pass it to template functions
	fwDevice_getHierarchy(deviceDpName, deviceHierarchy, exceptionInfo);
 	if (mappinglen(replacements) == 0) {
      replacements = fwDevice_getReplacementsFromDp(deviceDpName, exceptionInfo);
	}

	// read common device definitions
	switch(addressParameters[fwDevice_ADDRESS_TYPE])
	{
		case fwDevice_ADDRESS_OPC:
		case fwDevice_ADDRESS_DIM:
		case fwDevice_ADDRESS_MODBUS:
		case fwDevice_ADDRESS_S7:
		case fwDevice_ADDRESS_SNMP:
		case fwDevice_ADDRESS_OPCUA:
			driverNumber = (int) addressParameters[fwDevice_ADDRESS_DRIVER_NUMBER];
			dpGet(	definitionDp + fwDevice_ELEMENTS , dpElements,
					definitionDp + ".configuration.address." + addressParameters[fwDevice_ADDRESS_TYPE] + ".direction", addressModes);
			DebugFTN("FW_INFO", "fwDevice_setAddress(): addressModes ", addressModes);
			break;

		case fwDevice_ADDRESS_NONE:
			dpGet(definitionDp + fwDevice_ELEMENTS , dpElements);
			break;
		default:
			break;
	}

	// check whether selected properties (dpes) should be considered or all properties in the device
	if(dpes == "" || dpes == makeDynString(""))
		withSelectedDpes = FALSE;
	else
		withSelectedDpes = TRUE;

	//get size of address object passed to function
	objectSize = dynlen(addressParameters);

//	t2 = getCurrentTime();

	//DebugN("fwDevice_setAddress(): Can have dp function for " + deviceDpName + " is " + canHaveDpFunction);
//	DebugN("fwDevice_setAddress(): dpElements " + dpElements);
	//DebugN("fwDevice_setAddress(): addressModes " + addressModes);
//  	DebugN("fwDevice_setAddress(): withSelectedDpes " + withSelectedDpes + " len of dpes " + dynlen(dpes));
	//DebugN("fwDevice_setAddress(): dpes ", dpes);

	// set addresses
	switch(addressParameters[fwDevice_ADDRESS_TYPE])
	{
		case fwDevice_ADDRESS_OPC:
		{
			bool individualOPCGroupIn, individualOPCGroupOut;
			string OPCGroup;
			dyn_string OPCGroups;

			dpGet(	definitionDp + ".configuration.address.OPC.items", items,
					definitionDp + ".configuration.address.OPC.groups", OPCGroups);

			// common parameters for all elements
			if(objectSize < fwPeriphAddress_OPC_OBJECT_SIZE)
				addressParameters[fwPeriphAddress_OPC_OBJECT_SIZE] = "";

			if(addressParameters[fwPeriphAddress_DATATYPE] == "")
				addressParameters[fwPeriphAddress_DATATYPE]		= 0;
			if(addressParameters[fwPeriphAddress_ACTIVE] == "")
				addressParameters[fwPeriphAddress_ACTIVE]		= 1;
			if(addressParameters[fwPeriphAddress_OPC_LOWLEVEL] == "")
				addressParameters[fwPeriphAddress_OPC_LOWLEVEL] 	= 0;
			if(addressParameters[fwPeriphAddress_OPC_SUBINDEX] == "")
				addressParameters[fwPeriphAddress_OPC_SUBINDEX] 	= 0;

			//DebugN("fwDevice_setAddress(): addressParameters & OPC groups ", addressParameters, OPCGroups);

			// Check whether to use individual or common OPC groups
			// OPC groups can contain references to be replaced
			if(addressParameters[fwDevice_ADDRESS_OPC_GROUP_IN] == "")
			{
				individualOPCGroupIn = true;
			}
			else
			{
				individualOPCGroupIn = false;
				fwDevice_processAddressTemplate(deviceDpName, addressParameters[fwDevice_ADDRESS_OPC_GROUP_IN],
												addressParameters[fwDevice_ADDRESS_OPC_GROUP_IN], exceptionInfo, "",replacements);
			}

			if(addressParameters[fwDevice_ADDRESS_OPC_GROUP_OUT] == "")
			{
				individualOPCGroupOut = true;
			}
			else
			{
				individualOPCGroupOut = false;
				fwDevice_processAddressTemplate(deviceDpName, addressParameters[fwDevice_ADDRESS_OPC_GROUP_OUT],
												addressParameters[fwDevice_ADDRESS_OPC_GROUP_OUT], exceptionInfo,"", replacements);
			}

			//DebugN("Individual OPC group in: " + individualOPCGroupIn + " Individual OPC group out: " + individualOPCGroupOut);

			for (int i = 1; i <= dynlen(dpElements); i++)
			{
				// if a list of dpes was passed and the current element to be processed is not
				// in the list then skip it
				if(withSelectedDpes)
				{
					if(dynContains(dpes, dpElements[i]) == 0)
					{
						continue;
					}
				}

				//DebugN("Setting address for element: " + dpElements[i]);
//				t3 = getCurrentTime();
				// see if address mode is valid, and correspondant OPC group
				hasAddress = FALSE;
				if(	dynContains(fwDevice_ADDRESS_DIR_INPUT, addressModes[i]) > 0 ||
					dynContains(fwDevice_ADDRESS_DIR_OUTPUT, addressModes[i]) > 0 ||
					dynContains(fwDevice_ADDRESS_DIR_INPUT_OUTPUT, addressModes[i]) > 0)
				{
					//OPCGroup = addressParameters[fwDevice_ADDRESS_OPC_MODE_TO_GROUP_MAPPING[addressModes[i]]];
					hasAddress = TRUE;
				}

				// set address
				if(hasAddress)
				{
					// set OPC group depending on direction and whether it is individual or common groups
					if(dynContains(fwDevice_ADDRESS_DIR_INPUT, addressModes[i]) > 0)
					{
						if(individualOPCGroupIn)
						{
							addressParameters[fwDevice_ADDRESS_OPC_GROUP_IN] = OPCGroups[i];
							fwDevice_processAddressTemplate(	deviceDpName, addressParameters[fwDevice_ADDRESS_OPC_GROUP_IN],
																addressParameters[fwDevice_ADDRESS_OPC_GROUP_IN], exceptionInfo, "",replacements);
						}
					}
					else	// output address
					{
						if(individualOPCGroupOut)
						{
							addressParameters[fwDevice_ADDRESS_OPC_GROUP_OUT] = OPCGroups[i];
							fwDevice_processAddressTemplate(	deviceDpName, addressParameters[fwDevice_ADDRESS_OPC_GROUP_OUT],
																addressParameters[fwDevice_ADDRESS_OPC_GROUP_OUT], exceptionInfo,"",replacements);
						}
					}

					//DebugN("OPCGroup " + OPCGroups[i] + " " + addressParameters[fwDevice_ADDRESS_OPC_MODE_TO_GROUP_MAPPING[addressModes[i]]] + " mode " + addressModes[i]);

//					t4 = getCurrentTime();
					fwDevice_processAddressTemplate(deviceDpName, items[i], items[i], exceptionInfo, deviceHierarchy);

//					t5 = getCurrentTime();
					addressParameters[fwDevice_ADDRESS_ROOT_NAME]	= itemPrefix + items[i];
					addressParameters[fwPeriphAddress_DIRECTION]	= addressModes[i];

					fwPeriphAddress_set(deviceDpName + dpElements[i], addressParameters, exceptionInfo, FALSE);
					DebugFTN("FW_INFO", "fwDevice_setAddress(): setting OPC address " + addressParameters);

//					t6 = getCurrentTime();
				}

//				DebugN("add: " + deviceDpName + dpElements[i], t6 - t5, t5 - t4, t4 - t3);
			}
			break;
		}

		case fwDevice_ADDRESS_OPCUA: {
			bool       individualOPCUASubscriptionIn, individualOPCUASubscriptionOut;
			string     OPCGroup;
			dyn_string OPCSubscriptions;
			dyn_string OPCKinds;
			dyn_string OPCVariants;
   dyn_int    OPCUAtypes;
   dyn_string OPCUApollGroups;

			dpGet(
     definitionDp + ".configuration.address.OPCUA.items", items,
					definitionDp + ".configuration.address.OPCUA.subscriptions", OPCSubscriptions,
					definitionDp + ".configuration.address.OPCUA.kinds", OPCKinds,
					definitionDp + ".configuration.address.OPCUA.variants", OPCVariants,
     definitionDp + ".configuration.address.OPCUA.types", OPCUAtypes,
     definitionDp + ".configuration.address.OPCUA.pollGroups", OPCUApollGroups
   );

			// common parameters for all elements
			if(objectSize < fwPeriphAddress_OPCUA_OBJECT_SIZE)
				addressParameters[fwPeriphAddress_OPCUA_OBJECT_SIZE] = "";
			if(addressParameters[fwPeriphAddress_DATATYPE] == "" || addressParameters[fwPeriphAddress_DATATYPE] == fwDevice_DEFINITION_EMPTY_ENTRY)
				addressParameters[fwPeriphAddress_DATATYPE]		= 0;
			if(addressParameters[fwPeriphAddress_ACTIVE] == "" || addressParameters[fwPeriphAddress_ACTIVE] == fwDevice_DEFINITION_EMPTY_ENTRY)
				addressParameters[fwPeriphAddress_ACTIVE]		= 1;
   //TODO low level to be implemented in the device template
			if(addressParameters[fwPeriphAddress_OPCUA_LOWLEVEL] == "" || addressParameters[fwPeriphAddress_OPCUA_LOWLEVEL] == fwDevice_DEFINITION_EMPTY_ENTRY)
				addressParameters[fwPeriphAddress_OPCUA_LOWLEVEL] 	= 0;

			// Check whether to use individual or common OPC UA subscriptions
			// OPC UA subscriptions can contain references to be replaced
			if(addressParameters[fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_IN] == "") {
				  individualOPCUASubscriptionIn = true;
			} else {
  				individualOPCUASubscriptionIn = false;
  				fwDevice_processAddressTemplate(
          deviceDpName,
          addressParameters[fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_IN],
  								addressParameters[fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_IN],
          exceptionInfo,
          "",
          replacements
      );
			}

			if(addressParameters[fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_OUT] == "") {
				individualOPCUASubscriptionOut = true;
			} else {
				individualOPCUASubscriptionOut = false;
				  fwDevice_processAddressTemplate(
        deviceDpName,
        addressParameters[fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_OUT],
								addressParameters[fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_OUT],
        exceptionInfo,
        "",
        replacements
      );
			}
   int len = dynlen(dpElements);
			for(int i = 1; i <= len; i++) {
				// if a list of dpes was passed and the current element to be processed is not
				// in the list then skip it
				if(withSelectedDpes) {
					if(dynContains(dpes, dpElements[i]) == 0) {
						continue;
					}
				}

				// see if address mode is valid, and correspondant OPC group
				hasAddress = FALSE;
				if (dynContains(fwDevice_ADDRESS_DIR_INPUT, addressModes[i]) > 0 ||
					  dynContains(fwDevice_ADDRESS_DIR_OUTPUT, addressModes[i]) > 0 ||
					  dynContains(fwDevice_ADDRESS_DIR_INPUT_OUTPUT, addressModes[i]) > 0)	{
					hasAddress = TRUE;
				}

				// set address
				if(hasAddress) {
					// set OPC group depending on direction and whether it is individual or common groups
					if(dynContains(fwDevice_ADDRESS_DIR_INPUT, addressModes[i]) > 0) {
						if(individualOPCUASubscriptionIn) {
							addressParameters[fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_IN] = OPCSubscriptions[i];
							fwDevice_processAddressTemplate(	deviceDpName, addressParameters[fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_IN],
																addressParameters[fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_IN], exceptionInfo, "",replacements);
						}
					} else	{ //output address
						if(individualOPCUASubscriptionOut) {
							addressParameters[fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_OUT] = OPCSubscriptions[i];
							fwDevice_processAddressTemplate(	deviceDpName, addressParameters[fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_OUT],
																addressParameters[fwDevice_ADDRESS_OPCUA_SUBSCRIPTION_OUT], exceptionInfo,"",replacements);
						}
					}

     if((items[i] != "") && (items[i] != fwDevice_DEFINITION_EMPTY_ENTRY)) {
					  fwDevice_processAddressTemplate(deviceDpName, items[i], items[i], exceptionInfo, deviceHierarchy);
					  addressParameters[fwDevice_ADDRESS_ROOT_NAME]		= itemPrefix + items[i];
     }

     if((addressModes[i] != "") && (addressModes[i] != fwDevice_DEFINITION_EMPTY_ENTRY)) {
					  addressParameters[fwPeriphAddress_DIRECTION]		= addressModes[i];
     }

     if (dynlen(OPCKinds) < i || OPCKinds[i] == "" || OPCKinds[i] == fwDevice_DEFINITION_EMPTY_ENTRY) {
       OPCKinds[i] = 1;
     }
					addressParameters[fwDevice_ADDRESS_OPCUA_KIND]		  = OPCKinds[i];

     if (dynlen(OPCVariants) < i || OPCVariants[i] == "" || OPCVariants[i] == fwDevice_DEFINITION_EMPTY_ENTRY) {
       OPCVariants[i] = 1;
     }
					addressParameters[fwDevice_ADDRESS_OPCUA_VARIANT]	= OPCVariants[i];

     if (dynlen(OPCUApollGroups) < i || OPCUApollGroups[i] == "" || OPCUApollGroups[i] == fwDevice_DEFINITION_EMPTY_ENTRY) {
       addressParameters[fwPeriphAddress_OPCUA_POLL_GROUP] = "";
     } else {
       addressParameters[fwPeriphAddress_OPCUA_POLL_GROUP] = OPCUApollGroups[i];
     }

     for (int ap_i = 1; ap_i <= dynlen(addressParameters); ap_i++) {
       if (addressParameters[ap_i] == fwDevice_DEFINITION_EMPTY_ENTRY) {
         addressParameters[ap_i] = "";
       }
     }

     if((OPCUAtypes[i] != "") && (OPCUAtypes[i] != fwDevice_DEFINITION_EMPTY_ENTRY)) {
       addressParameters[fwPeriphAddress_DATATYPE]	= OPCUAtypes[i];
     } else {
       addressParameters[fwPeriphAddress_DATATYPE] = 750;//default
     }



     DebugFTN("FW_INFO", "setting address for " + deviceDpName + dpElements[i], addressParameters);
					fwPeriphAddress_set(deviceDpName + dpElements[i], addressParameters, exceptionInfo, FALSE);
				}
			}//end for
			break;
		}

		case fwDevice_ADDRESS_DIM:
		{
			//bool timeStamp = addressParameters[fwDevice_ADDRESS_DIM_TIME_STAMP];
			//int timeInterval = addressParameters[fwDevice_ADDRESS_DIM_TIME_INTERVAL];

//			DebugN("addressParameters " + addressParameters);

			// common parameters for all elements
			if(objectSize < fwPeriphAddress_DIM_OBJECT_SIZE)
				addressParameters[fwPeriphAddress_DIM_OBJECT_SIZE] = "";

			if(addressParameters[fwPeriphAddress_DIM_CONFIG_DP] == "")
				addressParameters[fwPeriphAddress_DIM_CONFIG_DP]		= "fwDimDefaultConfig"; // not clear if null means default
			if(addressParameters[fwPeriphAddress_DIM_DEFAULT_VALUE] == "")
				addressParameters[fwPeriphAddress_DIM_DEFAULT_VALUE]		= "";
			if(addressParameters[fwPeriphAddress_DIM_TIMEOUT] == "")
				addressParameters[fwPeriphAddress_DIM_TIMEOUT]			= 0;
			if(addressParameters[fwPeriphAddress_DIM_FLAG] == "")
				addressParameters[fwPeriphAddress_DIM_FLAG]			= (int) true;
			if(addressParameters[fwPeriphAddress_DIM_IMMEDIATE_UPDATE] == "")
				addressParameters[fwPeriphAddress_DIM_IMMEDIATE_UPDATE] 	= (int) true;

//			DebugN("addressParameters " + addressParameters);

			dpGet(definitionDp + ".configuration.address.DIM.items", items);
			for(int i = 1; i <= dynlen(dpElements); i++)
			{
				// if a list of dpes was passed and the current element to be processed is not
				// in the list then skip it
				if(withSelectedDpes)
				{
					if(dynContains(dpes, dpElements[i]) == 0)
					{
						continue;
					}
				}

				if (addressModes[i] != DPATTR_ADDR_MODE_UNDEFINED)
				{
					fwDevice_processAddressTemplate(deviceDpName, items[i], items[i], exceptionInfo);
					addressParameters[fwDevice_ADDRESS_ROOT_NAME]	= itemPrefix + items[i];

					addressParameters[fwPeriphAddress_DIRECTION]	= addressModes[i];

					fwPeriphAddress_set(deviceDpName + dpElements[i], addressParameters, exceptionInfo, FALSE);
				}
			}
			break;
		}
		case fwDevice_ADDRESS_S7:
		{
			dyn_int S7types;
			dyn_string S7groups;
			dyn_bool lowLevel;
			bool autoSmooth;

			addressParameters[fwPeriphAddress_ACTIVE] = TRUE;
			dpGet(	definitionDp + ".configuration.address.S7.items",	items,
					definitionDp + ".configuration.address.S7.types",	S7types,
					definitionDp + ".configuration.address.S7.groups",	S7groups,
					definitionDp + ".configuration.address.S7.lowLevel", lowLevel,
					definitionDp  + ".configuration.address.S7.general.autoSmooth", autoSmooth);

			for(int i = 1; i <= dynlen(dpElements); i++)
			{
				// if a list of dpes was passed and the current element to be processed is not
		      	// in the list then skip it
		      				if(withSelectedDpes)
		      				{
		      					if(dynContains(dpes, dpElements[i]) == 0)
		      					{
		      						continue;
		      					}
		      				}
		          	if((items[i] != "") && (items[i] != fwDevice_DEFINITION_EMPTY_ENTRY))
		        		{
		          			fwDevice_processAddressTemplate(deviceDpName,  items[i],  items[i], exceptionInfo, deviceHierarchy, replacements);

		              if (S7groups[i]== fwDevice_DEFINITION_EMPTY_ENTRY) S7groups[i] = "";
		              addressParameters[fwPeriphAddress_S7_POLL_GROUP]=S7groups[i];
		              addressParameters[fwPeriphAddress_REFERENCE]= items[i];
		              addressParameters[fwPeriphAddress_DATATYPE]=S7types[i];
		              addressParameters[fwPeriphAddress_S7_LOWLEVEL]=lowLevel[i] ;
		              addressParameters[fwPeriphAddress_DIRECTION] = addressModes[i];


		              fwPeriphAddress_set(deviceDpName + dpElements[i], addressParameters, exceptionInfo, FALSE ) ;
		              bool smooth;

		              if (addressParameters[fwPeriphAddress_DIRECTION]==1) {
		               // 4 is input 1 is output
		               smooth = false;
		              } else {
		                 smooth = autoSmooth;
		              }

		              if (smooth) {
		                 fwSmoothing_set(deviceDpName + dpElements[i], DPATTR_COMPARE_OLD_NEW,  0, 0, exceptionInfo);
		              }
		            }
		       }
		    break;
		   }
  case fwDevice_ADDRESS_SNMP:
   {
   bool autoSmooth;
   dyn_int SNMPtypes;
   dyn_string SNMPgroups, subindexes, agentIds, agentVersions;

   addressParameters[fwPeriphAddress_ACTIVE]=TRUE;

 			dpGet(definitionDp + ".configuration.address.SNMP.items", items,
            definitionDp + ".configuration.address.SNMP.types", SNMPtypes,
            definitionDp + ".configuration.address.SNMP.groups", SNMPgroups,
            definitionDp + ".configuration.address.SNMP.subindexes", subindexes,
            definitionDp + ".configuration.address.SNMP.agentIds", agentIds,
            definitionDp + ".configuration.address.SNMP.agentVersions", agentVersions,
            definitionDp  + ".configuration.address.SNMP.general.autoSmooth", autoSmooth);

    	for(int i = 1; i <= dynlen(dpElements); i++) {
         	// if a list of dpes was passed and the current element to be processed is not
      				// in the list then skip it
      				if(withSelectedDpes)
      				{
      					if(dynContains(dpes, dpElements[i]) == 0)
      					{
      						continue;
      					}
      				}
          	if((items[i] != "") && (items[i] != fwDevice_DEFINITION_EMPTY_ENTRY))
        		{
          		fwDevice_processAddressTemplate(deviceDpName,  items[i],  items[i], exceptionInfo, deviceHierarchy, replacements);
          		fwDevice_processAddressTemplate(deviceDpName,  subindexes[i],  subindexes[i], exceptionInfo, deviceHierarchy, replacements);
          		fwDevice_processAddressTemplate(deviceDpName,  agentIds[i],  agentIds[i], exceptionInfo, deviceHierarchy, replacements);

              addressParameters[fwPeriphAddress_SNMP_POLL_GROUP]=SNMPgroups[i];
              addressParameters[fwPeriphAddress_REFERENCE]= items[i];
              addressParameters[fwPeriphAddress_DATATYPE]=SNMPtypes[i];
              addressParameters[fwPeriphAddress_SNMP_SUBINDEX]=subindexes[i];
              addressParameters[fwPeriphAddress_SNMP_AGENT_ID]=agentIds[i];
              addressParameters[fwPeriphAddress_SNMP_AGENT_VERSION]=agentVersions[i];
              addressParameters[fwPeriphAddress_DIRECTION] = addressModes[i];

              fwPeriphAddress_set(deviceDpName + dpElements[i], addressParameters, exceptionInfo, FALSE);

              bool smooth;
              if(addressParameters[fwPeriphAddress_DIRECTION]==DPATTR_ADDR_MODE_OUTPUT_SINGLE)
              {
               smooth = false;
              } else {
                 smooth = autoSmooth;
              }

              if (smooth) {
                 fwSmoothing_set(deviceDpName + dpElements[i], DPATTR_COMPARE_OLD_NEW,  0, 0, exceptionInfo);
              }
            }
       }
    break;
   }
		case fwDevice_ADDRESS_MODBUS:
		{

    dyn_uint dataType, subIndex;
    dyn_bool lowLevel;
    dyn_string pollGroup;

    addressParameters[fwPeriphAddress_ACTIVE] = TRUE;
    dpGet(	definitionDp + ".configuration.address.MODBUS.items",	items,
           definitionDp + ".configuration.address.MODBUS.dataType",	dataType,
           definitionDp + ".configuration.address.MODBUS.lowLevel",	lowLevel,
           definitionDp + ".configuration.address.MODBUS.pollGroup",	pollGroup,
           definitionDp + ".configuration.address.MODBUS.subIndex",	subIndex);

    for(int i = 1; i <= dynlen(dpElements); i++){
      if(withSelectedDpes && dynContains(dpes, dpElements[i]) == 0)
        continue;

      if((items[i] != "") && (items[i] != fwDevice_DEFINITION_EMPTY_ENTRY)){
        fwDevice_processAddressTemplate(deviceDpName,  items[i],  items[i], exceptionInfo, deviceHierarchy, replacements);

        if (pollGroup[i] == fwDevice_DEFINITION_EMPTY_ENTRY) pollGroup[i] = "";

        addressParameters[fwPeriphAddress_REFERENCE] = items[i];
        addressParameters[fwPeriphAddress_DATATYPE] = dataType[i];
        addressParameters[fwPeriphAddress_MODBUS_LOWLEVEL] = lowLevel[i] ;
        addressParameters[fwPeriphAddress_MODBUS_POLL_GROUP] = pollGroup[i];
        addressParameters[fwPeriphAddress_MODBUS_SUBINDEX] = subIndex[i];

        	addressParameters[fwPeriphAddress_DIRECTION]	= addressModes[i];

        fwPeriphAddress_set(deviceDpName + dpElements[i], addressParameters, exceptionInfo, FALSE );
      }
    }
   break;
 }
		case fwDevice_ADDRESS_NONE:
		{
			// delete addresses for all dpes (not taking into account device definititon
			for(int i = 1; i <= dynlen(dpElements); i++)
			{
				// if a list of dpes was passed and the current element to be processed is not
				// in the list then skip it
				if(withSelectedDpes)
				{
					if(dynContains(dpes, dpElements[i]) == 0)
					{
						continue;
					}
				}
				dynAppend(elementsToDelete, deviceDpName + dpElements[i]);
			}

			// delete addresses
			fwPeriphAddress_deleteMultiple(elementsToDelete, exceptionInfo);
			break;
		}
		default:
			break;
	}

	// set dp Functions	if no property list was passed
	if(!withSelectedDpes)
	{
		if (addressParameters[fwDevice_ADDRESS_TYPE]!=fwDevice_ADDRESS_NONE) {
		      fwDevice_setDpFunction(	deviceDpName, fwDevice_DPFUNCTION_SET, exceptionInfo, definitionDp, deviceHierarchy);
		} else {
		      fwDevice_setDpFunction(	deviceDpName, fwDevice_DPFUNCTION_UNSET, exceptionInfo, definitionDp, deviceHierarchy);
		}
	}

//	tn = getCurrentTime();

//	DebugN("fwDevice_setAddress(): " + deviceDpName, tn - t1);
//	dt = t2 - t1;
//	DebugN(dt);
//	dt = tn - t1;
//	DebugN(dt);
}


/** Sets the dp function for the given device with the given parameters.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName		dp name of the device (e.g. CAEN/crate003/board07/channel005)
@param operation		operation to be performed:
							-Set DpFunction: fwDevice_DPFUNCTION_SET
							-Unset DpFunction: fwDevice_DPFUNCTION_UNSET
@param exceptionInfo	details of any exceptions
@param definitionDp		where to read the device definition. It is optional. If it is required by the function
						and it has not been passed, the function will get it
@param deviceHierarchy 	device hierarchy above deviceDpName (including it). It is optional. If it is required
						by the function and it has not been passed, the function will get it
@param replacements mapping of the replacments to pass to generate the dp function from template. If empty it is filled automatically based on the default values
@param skipNotExisting skip dp function depending from other data points if the other data point does not exist
*/
fwDevice_setDpFunction(	string deviceDpName, string operation, dyn_string &exceptionInfo,
						string definitionDp = "", dyn_dyn_string deviceHierarchy = "", mapping replacements = fwDevice_emptyMap, bool skipNotExisting = false, dyn_string selectedDpes = "")
{
	int i, j;
	string deviceModel;
	dyn_bool canHaveDpFunction;
 bool withSelectedDpes = !(selectedDpes == "" || selectedDpes == makeDynString(""));
	dyn_string dpElements, dpFunctions, dpParams, dpParamsList, device, elementsToDelete;
 bool notExisting;

	// check if device exists
	if(!dpExists(deviceDpName))
	{
		fwException_raise(	exceptionInfo,
							"ERROR",
							"fwDevice_setDpFunction(): " + deviceDpName + " does not exist",
							"");
		return;
	}

	// where to look for device definition if it was not passed as parameter
	if(definitionDp == "")
	{
		// create device object
		device = makeDynString(deviceDpName, dpTypeName(deviceDpName), "", "");

		// fill in model information
		fwDevice_getModel(device, deviceModel, exceptionInfo);
		if (dynlen(exceptionInfo)) return;

		device[fwDevice_MODEL] = deviceModel;

		fwDevice_getDefinitionDp(device, definitionDp, exceptionInfo);
		if (dynlen(exceptionInfo)) return;
		if(definitionDp == "")
			return;
		//	DebugN("fwDevice_setDpFunction(): ", device, definitionDp);
	}


	switch(operation)
	{
		case fwDevice_DPFUNCTION_SET:
		 if (mappinglen(replacements) == 0) {
     replacements = fwDevice_getReplacementsFromDp(deviceDpName, exceptionInfo);
   }

			// get information from device definition
			dpGet(	definitionDp + fwDevice_ELEMENTS , 						dpElements,
					definitionDp + ".configuration.dpFunction.canHave", 	canHaveDpFunction,
					definitionDp + ".configuration.dpFunction.function",	dpFunctions,
					definitionDp + ".configuration.dpFunction.params", 		dpParams);

			// get hierarchy if it was not passed as parameter
			if(deviceHierarchy == "")
			{
				// get the device hierarchy to pass it to template functions
				fwDevice_getHierarchy(deviceDpName, deviceHierarchy, exceptionInfo);
			}


			// set dp Functions
			for(i = 1; i <= dynlen(dpElements); i++)
			{
				if(canHaveDpFunction[i] && (strtoupper(dpFunctions[i]) != fwDevice_DEFINITION_EMPTY_ENTRY) )
				{
     if(withSelectedDpes) {
  					if(dynContains(selectedDpes, dpElements[i]) == 0) {
  						 continue;
  					}
				 }
					//DebugN("Setting DP function for " + dpElements[i]);
					fwGeneral_stringToDynString(dpParams[i], dpParamsList);
     notExisting = false;

					for(j = 1; j <= dynlen(dpParamsList); j++)
					{
						fwDevice_processAddressTemplate(deviceDpName, dpParamsList[j], dpParamsList[j], exceptionInfo, deviceHierarchy, replacements);

						// if the parameter starts with "." it means it is relative to the dp being processed
						if(strpos(dpParamsList[j], ".") == 0)
							dpParamsList[j] = deviceDpName + dpParamsList[j];
      else if (skipNotExisting) {
        if (! dpExists(dpParamsList[j])) {
            notExisting = true;
        }
      }
					}
     if (notExisting) continue;
					fwDevice_processAddressTemplate(deviceDpName, dpFunctions[i], dpFunctions[i], exceptionInfo, deviceHierarchy, replacements);

					//DebugN("fwDevice_setDpFunction(): deviceDpName + dpElements[i] " + deviceDpName + dpElements[i]);
					//DebugN("fwDevice_setDpFunction(): dpParamsList " + dpParamsList);
					//DebugN("fwDevice_setDpFunction(): dpFunctions[i] " + dpFunctions[i]);
					fwDpFunction_setDpeConnection(	deviceDpName + dpElements[i], dpParamsList,
													makeDynString(), dpFunctions[i], exceptionInfo);
					// DebugN("fwDevice_setDpFunction(): " + exceptionInfo);
				}
			}
			break;
		case fwDevice_DPFUNCTION_UNSET:

			// get device definition information
			dpGet(	definitionDp + fwDevice_ELEMENTS , 						dpElements,
					definitionDp + ".configuration.dpFunction.canHave", 	canHaveDpFunction);

			// unset dp Functions
			for(i = 1; i <= dynlen(dpElements); i++)
			{
				if(canHaveDpFunction[i])
				{
     if(withSelectedDpes) {
  					if(dynContains(selectedDpes, dpElements[i]) == 0) {
  						 continue;
  					}
				 }
					dynAppend(elementsToDelete, deviceDpName + dpElements[i]);
				}
			}

			fwDpFunction_deleteMany(elementsToDelete, exceptionInfo);
			break;
		default:
			break;
	}
}

/** Sets the dp function for the given device and all of its children in
the specified hierarchy with the given parameters. By default the hardware
hierarchy is used.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName		dp name of the device (e.g. CAEN/crate003/board07/channel005)
@param operation		operation to be performed:
							-Set DpFunction: fwDevice_DPFUNCTION_SET
							-Unset DpFunction: fwDevice_DPFUNCTION_UNSET
@param exceptionInfo	details of any exceptions
@param definitionDp		where to read the device definition. It is optional. If it is required by the function
						and it has not been passed, the function will get it
@param deviceHierarchy 	device hierarchy above deviceDpName (including it). It is optional. If it is required
						by the function and it has not been passed, the function will get it
@param hierarchyType	hierarchy where to apply the recursive action
							-fwDevice_HARDWARE
							-fwDevice_LOGICAL
*/
fwDevice_setDpFunctionRecursively(	string deviceDpName, string operation, dyn_string &exceptionInfo,
									string definitionDp = "", dyn_dyn_string deviceHierarchy = "",
									string hierarchyType = fwDevice_HARDWARE)
{
	int i;
	dyn_string children;

	//DebugN("fwDevice_setDpFunctionRecursively " + hierarchyType);
	// set address for the device
	fwDevice_setDpFunction(	deviceDpName, operation, exceptionInfo,
							definitionDp, deviceHierarchy, hierarchyType);
	if(dynlen(exceptionInfo) > 0)
		return;

	// set archive for the children of the device
	fwDevice_getChildren(deviceDpName, hierarchyType, children, exceptionInfo);
	for(i = 1; i <= dynlen(children); i++)
	{
		// dp with definition and hierarchy cannot be reused for children devices
		fwDevice_setDpFunctionRecursively(	deviceDpName, operation, exceptionInfo, "", "", hierarchyType);
	}
}

/** Sets the address for the given device and all of its children in
the hardware hierarchy, with the given parameters.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName			dp name of the device (e.g. CAEN/crate003/board07)
@param addressParameters	parameters to be used when setting the address
@param exceptionInfo		details of any exceptions
@param hierarchyType		hierarchy where to apply the recursive action
								-fwDevice_HARDWARE
								-fwDevice_LOGICAL
							the default value is fwDevice_HARDWARE. The constant cannot be used because of the PVSS
							bug when using default values in recursive functions
*/
fwDevice_setAddressRecursively(string deviceDpName, dyn_string addressParameters, dyn_string &exceptionInfo, string hierarchyType = "HARDWARE")
{
	int i;
	dyn_string children, dpes;

	//DebugN("fwDevice_setAddressRecursively " + addressParameters);
	// set address for the device
	fwDevice_setAddress(deviceDpName, addressParameters, exceptionInfo);
	if(dynlen(exceptionInfo) > 0)
		return;

	// set archive for the children of the device
	fwDevice_getChildren(deviceDpName, hierarchyType, children, exceptionInfo);
	for(i = 1; i <= dynlen(children); i++)
	{
		fwDevice_setAddressRecursively(children[i], addressParameters, exceptionInfo, hierarchyType);
	}
}


/** This function can be used to perform several operations on the alert
config of the given device, based on the device definition information:
	<li> Set the alert for the dpes that can have a default according to the definition (operation = fwDevice_ALERT_SET)
	<li> Unset the alert for the dpes that can have it according to the definition (operation = fwDevice_ALERT_UNSET)
	<li> Mask the alert for the dpes that can have it according to the definition (operation = fwDevice_ALERT_MASK)
	<li> Unmask the alert for the dpes that can have it according to the definition (operation = fwDevice_ALERT_UNMASK)
	<li> Acknowledge the alert for the dpes that can have it according to the definition (operation = fwDevice_ALERT_ACK)
	<li> Unset the summary alert (operation = fwDevice_ALERT_SUMMARY_UNSET)

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName		dp name of the device (e.g. CAEN/crate003/board07/channel005)
@param operation		operation to be performed as specified in the description
@param exceptionInfo	details of any exceptions
*/
fwDevice_setAlert(string deviceDpName, string operation, dyn_string &exceptionInfo, dyn_string selectedDpes = "")
{
	int i, type;
 bool withSelectedDpes = !(selectedDpes == "" || selectedDpes == makeDynString(""));
	string	deviceType, deviceDpParent, definitionDp;
	dyn_bool canHaveAlert;
	dyn_string dpElements, alertClasses, alertTexts, alertLimits, alertClass, alertText, alertLimit, dpes;

	DebugFTN("FW_INFO", "fwDevice_setAlert(" + deviceDpName + ", " + operation + ")", dpes);

	fwDevice_getDefinitionDp(makeDynString(deviceDpName), definitionDp, exceptionInfo);
 if(definitionDp == "") {
   DebugFTN("FW_INFO", "definitionDp does not exist");
		 return;
 }

	dpGet(	definitionDp + fwDevice_ELEMENTS, dpElements,
			definitionDp + fwDevice_CONFIG_CAN_HAVE[fwDevice_ALERT_INDEX], canHaveAlert);

	switch(operation)
	{
		case fwDevice_ALERT_SET:
   DebugFTN("FW_INFO", "ALERT SET for " + deviceDpName, dpElements, canHaveAlert);
			dpGet(	definitionDp + ".configuration.alert.defaultClasses", alertClasses,
					definitionDp + ".configuration.alert.defaultTexts", alertTexts,
					definitionDp + ".configuration.alert.defaultLimits", alertLimits,
					deviceDpName + "." +  ":_alert_hdl.._type", type);

			// Fill in fields in case they don't have the right length
			fwGeneral_fillDynString(alertClasses, dynlen(dpElements), exceptionInfo);
			fwGeneral_fillDynString(alertTexts, dynlen(dpElements), exceptionInfo);
			fwGeneral_fillDynString(alertLimits, dynlen(dpElements), exceptionInfo);

			//DebugN("fwDevice_setAlert(): fwDevice_ALERT_SET", alertClasses, alertTexts);
			// Create summary for the device if it hasn't got one
			if(type == DPCONFIG_NONE)
			{
				fwAlertConfig_setSummary(	deviceDpName + ".",
											makeDynString("Ok", "Bad"),
											makeDynString(),				// dpelementList
											"",								// alertPanel
											makeDynString(), 				// alertPanelParameter
											"",								// alertHelp
											exceptionInfo,
											FALSE);
			}

			// set the default alert configs
			for(i = 1; i <= dynlen(dpElements); i++)
			{
				if ((canHaveAlert[i]) && (strtoupper(alertClasses[i]) != fwDevice_DEFINITION_EMPTY_ENTRY))
				{
     if(withSelectedDpes) {
  					if(dynContains(selectedDpes, dpElements[i]) == 0) {
  						 continue;
  					}
				 }
     DebugFTN("FW_INFO", "Added alert to " + dpElements[i]);
					fwGeneral_stringToDynString(alertClasses[i], alertClass);
					fwGeneral_stringToDynString(alertTexts[i], alertText,"|",false); // don't remove spaces
					fwGeneral_stringToDynString(alertLimits[i], alertLimit);
					fwAlertConfig_setGeneral(deviceDpName + dpElements[i],
											alertText,
											alertLimit,
											alertClass,
											"",
											makeDynString(),
											"",
											TRUE,
											exceptionInfo);

					// add dpe in the alert summary of the root dp
					dpGet(deviceDpName + dpElements[i] + ":_alert_hdl.._type", type);
					//DebugN(deviceDpName + dpElements[i] + ":_alert_hdl.._type", type);
					if (type != DPCONFIG_NONE)
					{
							fwAlertConfig_addDpInAlertSummary(deviceDpName + ".", deviceDpName + dpElements[i], exceptionInfo, false);
							//DebugN(exceptionInfo);
						}
					}
			}

			// add the alert summary of the device in the alert summary of the parent
			fwDevice_getParent(deviceDpName, deviceDpParent, exceptionInfo);
			//DebugN("Setting alert for deviceDpName " + deviceDpName + " with parent " + deviceDpParent);

			dpGet(deviceDpParent + "." +  ":_alert_hdl.._type", type);
			if(type != DPCONFIG_NONE)
			{
				fwAlertConfig_addDpInAlertSummary(deviceDpParent + ".", deviceDpName + ".", exceptionInfo, false);
			}
			break;
		case fwDevice_ALERT_UNSET:

			// unset the summary
			fwDevice_setAlert(deviceDpName, fwDevice_ALERT_SUMMARY_UNSET, exceptionInfo);

			// build list of dpes
			dpes = makeDynString();
			for(i = 1; i <= dynlen(dpElements); i++)
			{
				if(canHaveAlert[i])
				{
     if(withSelectedDpes) {
  					if(dynContains(selectedDpes, dpElements[i]) == 0) {
  						 continue;
  					}
				 }
					dynAppend(dpes, deviceDpName + dpElements[i]);
				}
			}
			fwAlertConfig_deleteMany(dpes, exceptionInfo);
			break;
		case fwDevice_ALERT_SUMMARY_UNSET:

			// check if summary exists
			dpGet(deviceDpName + "." +  ":_alert_hdl.._type", type);

			// unset summary for the device if it has got one
			if(type != DPCONFIG_NONE)
			{
				string deviceDpParent, deviceDpAliasParent;

				// remove from hardware parent summary
				fwDevice_getParent(deviceDpName, deviceDpParent, exceptionInfo);
				if(deviceDpParent != "")
					dpGet(deviceDpParent + "." +  ":_alert_hdl.._type", type);

				if(type != DPCONFIG_NONE)
					fwAlertConfig_deleteDpFromAlertSummary(deviceDpParent + ".", deviceDpName + ".", exceptionInfo, FALSE);

				// remove from logical parent summary
				fwDevice_getParent(dpGetAlias(deviceDpName + "."), deviceDpAliasParent, exceptionInfo);
				deviceDpParent = strrtrim(dpAliasToName(deviceDpAliasParent), ".");
				if(deviceDpParent != "")
				{
					dpGet(deviceDpParent + "." +  ":_alert_hdl.._type", type);
					if(type != DPCONFIG_NONE)
					{
						fwAlertConfig_deleteDpFromAlertSummary(dpAliasToName(deviceDpAliasParent), deviceDpName + ".", exceptionInfo, FALSE);
						//DebugN("Deleting dpe from summary");
					}
				}
				// remove summary
				fwAlertConfig_deleteSummary(deviceDpName + ".", exceptionInfo);
			}
			break;
		case fwDevice_ALERT_MASK:
			dpes = makeDynString();

			// include also summary alerts
			dynAppend(dpes, deviceDpName + ".");

			// build list of dpes
			for(i = 1; i <= dynlen(dpElements); i++)
			{
				if(canHaveAlert[i])
				{
     if(withSelectedDpes) {
  					if(dynContains(selectedDpes, dpElements[i]) == 0) {
  						 continue;
  					}
				 }
					dynAppend(dpes, deviceDpName + dpElements[i]);
				}
			}
			fwAlertConfig_deactivateMultiple(dpes, exceptionInfo);
			break;
		case fwDevice_ALERT_UNMASK:
			dpes = makeDynString();

			// include also summary alerts
			dynAppend(dpes, deviceDpName + ".");

			// build list of dpes
			for(i = 1; i <= dynlen(dpElements); i++)
			{
				if(canHaveAlert[i])
				{
     if(withSelectedDpes) {
  					if(dynContains(selectedDpes, dpElements[i]) == 0) {
  						 continue;
  					}
				 }
					dynAppend(dpes, deviceDpName + dpElements[i]);
				}
			}
//   DebugN("Activate multiple ", dpes);

			fwAlertConfig_activateMultiple(dpes, exceptionInfo);
			break;
		case fwDevice_ALERT_ACK:
			dpes = makeDynString();

			// build list of dpes
			for(i = 1; i <= dynlen(dpElements); i++)
			{
				if(canHaveAlert[i])
				{
     if(withSelectedDpes) {
  					if(dynContains(selectedDpes, dpElements[i]) == 0) {
  						 continue;
  					}
				 }
					dynAppend(dpes, deviceDpName + dpElements[i]);
				}
			}
			fwAlertConfig_acknowledgeMany(dpes, exceptionInfo);
			break;
		default:
			break;
	}
}


/** This function can be used to perform several operations on the alert
config of the given device and all of its children in the hardware hierarchy,
based on the device definition information:
	<li> Set the alert for the dpes that can have a default according to the default in the definition (operation = fwDevice_ALERT_SET)
	<li> Unset the alert for the dpes that can have it according to the definition (operation = fwDevice_ALERT_UNSET)
	<li> Mask the alert for the dpes that can have it according to the definition (operation = fwDevice_ALERT_MASK)
	<li> Unmask the alert for the dpes that can have it according to the definition (operation = fwDevice_ALERT_UNMASK)
	<li> Acknowledge the alert for the dpes that can have it according to the definition (operation = fwDevice_ALERT_ACK)
	<li> Unset the summary alert (operation = fwDevice_ALERT_SUMMARY_UNSET)

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName		dp name of the device (e.g. CAEN/crate003/board07)
@param operation		operation to be performed as specified in the description
@param exceptionInfo	details of any exceptions
@param hierarchyType	hierarchy where to apply the recursive action
							-fwDevice_HARDWARE
							-fwDevice_LOGICAL
						the default value is fwDevice_HARDWARE. The constant cannot be used because of the PVSS
						bug when using default values in recursive functions

*/
fwDevice_setAlertRecursively(string deviceDpName, string operation, dyn_string &exceptionInfo, string hierarchyType = "HARDWARE")
{
	int i;
	dyn_string children;

	// set alert for the device
	fwDevice_setAlert(deviceDpName, operation, exceptionInfo);
//	DebugN("Setting alert for: " + deviceDpName);
//	DebugN("hierarchyType: " + hierarchyType);
	// set alert for the children of the device
	fwDevice_getChildren(deviceDpName, hierarchyType, children, exceptionInfo);
//	DebugN("Children for " + deviceDpName + " in hierarchy type " + hierarchyType + " are " + children);
	for(i = 1; i <= dynlen(children); i++)
	{
		fwDevice_setAlertRecursively(children[i], operation, exceptionInfo, hierarchyType);
	}
}


/** This function can be used to perform several operations on the archive
config of the given device, based on the device definition information:
	<li> Set the archive for the dpes that can have it according to the default in the definition (operation = fwDevice_ARCHIVE_SET)
	<li> Unset the archive for the dpes that can have it according to the definition (operation = fwDevice_ARCHIVE_UNSET)

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName		dp name of the device (e.g. CAEN/crate003/board07/channel005)
@param archiveClass		name of the PVSS archive class to be used for the configs
@param operation		operation to be performed as specified in the description
@param exceptionInfo	details of any exceptions
*/
fwDevice_setArchive(string deviceDpName, string archiveClass, string operation, dyn_string &exceptionInfo)
{
	int i;
	string deviceDpType = dpTypeName(deviceDpName);
	string definitionDp, aClass;
	dyn_bool canHaveArchive;
	dyn_int smoothTypes, smoothProcedures;
	dyn_float deadbands, timeIntervals;
	dyn_string dpElements, defaultClasses;


	fwDevice_getDefinitionDp(makeDynString(deviceDpName), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	//DebugN("fwDevice_setArchive(): device name = " + deviceName);
	// not clear yet if one archive class should be used for whole fw
	if(archiveClass == "")
	{
		fwDevice_getArchiveClass(deviceDpType, archiveClass, exceptionInfo);
	}

	dpGet(definitionDp + fwDevice_ELEMENTS, dpElements,
			definitionDp + fwDevice_CONFIG_CAN_HAVE[fwDevice_ARCHIVE_INDEX], canHaveArchive,
			definitionDp + ".configuration.archive.defaultClass", defaultClasses,
			definitionDp + ".configuration.archive.smoothType", smoothTypes,
			definitionDp + ".configuration.archive.smoothProcedure", smoothProcedures,
			definitionDp + ".configuration.archive.deadband", deadbands,
			definitionDp + ".configuration.archive.timeInterval", timeIntervals);

	switch(operation)
	{
		case fwDevice_ARCHIVE_SET:
			for(i = 1; i <= dynlen(dpElements); i++)
			{
				if (canHaveArchive[i])
				{
					// If there is no default class specified, use the one passed to the function
					if (defaultClasses[i] != "" && defaultClasses[i] != "EMPTY")
						aClass = defaultClasses[i];
					else
						aClass = archiveClass;

					// If we have managed to find an archive class then we can set up the archiving
					if (aClass != "")
					{
						// For legacy reasons, consider that a value of 0 in the smooth type means no smoothing
						if (smoothTypes[i] == 0)
							smoothTypes[i] = DPATTR_ARCH_PROC_VALARCH;

						fwArchive_set(	deviceDpName + dpElements[i],
											aClass,
											smoothTypes[i],
											smoothProcedures[i],
											deadbands[i],
											timeIntervals[i],
											exceptionInfo);
					}
				}
			}
			break;
		case fwDevice_ARCHIVE_UNSET:
			for(i = 1; i <= dynlen(dpElements); i++)
			{
				if (canHaveArchive[i])
					fwArchive_delete(deviceDpName + dpElements[i], exceptionInfo);
			}
			break;
		default:
			break;
	}
}


/** This function can be used to perform several operations on the archive
config of the given device and all of its children in the hardware hierarchy,
based on the device definition information:
	<li> Set the archive for the dpes that can have it according to the definition (operation = fwDevice_ARCHIVE_SET)
	<li> Unset the archive for the dpes that can have it according to the definition (operation = fwDevice_ARCHIVE_UNSET)

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName		dp name of the device (e.g. CAEN/crate003/board07)
@param archiveClass		name of the PVSS archive class to be used for the configs
@param operation		operation to be performed as specified in the description
@param exceptionInfo	details of any exceptions
@param hierarchyType	hierarchy where to apply the recursive action
							-fwDevice_HARDWARE
							-fwDevice_LOGICAL
						the default value is fwDevice_HARDWARE. The constant cannot be used because of the PVSS
						bug when using default values in recursive functions

*/
fwDevice_setArchiveRecursively(string deviceDpName, string archiveClass, string operation, dyn_string &exceptionInfo, string hierarchyType = "HARDWARE")
{
	int i;
	dyn_string children;

	// set archive for the device
	fwDevice_setArchive(deviceDpName, archiveClass, operation, exceptionInfo);
	if(dynlen(exceptionInfo) > 0)
		return;

	// set archive for the children of the device
	fwDevice_getChildren(deviceDpName, hierarchyType, children, exceptionInfo);
	for(i = 1; i <= dynlen(children); i++)
	{
		fwDevice_setArchiveRecursively(children[i], archiveClass, operation, exceptionInfo, hierarchyType);
	}
}


/** Sets the default values for the dpes inside that have
a default value spedified in the device/model definition

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName		dp name of the device (e.g. CAEN/crate003/board07/channel005)
@param exceptionInfo	details of any exceptions
@param replacements variables to replace
*/
fwDevice_setDefaultValues(string deviceDpName, dyn_string &exceptionInfo, mapping replacements = fwDevice_emptyMap)
{
	bool isDyn;
	int k, elType, result;
	string 	dpe, definitionDp;
	dyn_string defaultValues, dpes, dynValue;
	dyn_dyn_string deviceHierarchy;

	fwDevice_getDefinitionDp(makeDynString(deviceDpName), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	// get the device hierarchy to pass it to template functions
	fwDevice_getHierarchy(deviceDpName, deviceHierarchy, exceptionInfo);

	result = dpGet(	definitionDp + ".properties.defaultValues", defaultValues,
					definitionDp + ".properties.dpes", dpes);

	for(int i = 1; i <= dynlen(defaultValues); i++)
	{
		if((defaultValues[i] != "") && (defaultValues[i] != fwDevice_DEFINITION_EMPTY_ENTRY))
		{
			dpe = deviceDpName + dpes[i];
			elType = dpElementType(dpe);
			fwGeneral_isDpeTypeDyn(elType, isDyn, exceptionInfo);
			if(isDyn)
			{
				fwGeneral_stringToDynString(defaultValues[i], dynValue);
    			// apply replacements
    			for (k = 1; k <= dynlen(dynValue); k++) {
  					fwDevice_processAddressTemplate(deviceDpName,  dynValue[k],  dynValue[k], exceptionInfo, deviceHierarchy, replacements);
    			}
				result = dpSet(dpe, dynValue);

				/*DebugN("dpe " + dpe + " result " + result);
				DebugN(dynValue);
				DebugN(defaultValues[i]);

				result = dpGet(dpe, dynValue);
				DebugN("dpe " + dpe + " result " + result);
				DebugN(dynValue);*/
			}
			else
			{
				fwDevice_processAddressTemplate(deviceDpName, defaultValues[i], defaultValues[i], exceptionInfo, deviceHierarchy, replacements);
				result = dpSet(dpe, defaultValues[i]);
			}
		}
	}
}


/** This function sets the model of a given device to the specified
string, if the device type supports to have models defined.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName		dp name of the device (e.g. CAEN/crate003/board07/channel005)
@param deviceModel		device model
@param exceptionInfo	details of any exceptions
*/
fwDevice_setModel(string deviceDpName, string deviceModel, dyn_string &exceptionInfo)
{
	bool exists;
	unsigned dpId;
	int elId;

	exists = dpGetId (deviceDpName + ".model", dpId, elId);

	if (exists)
		dpSet(deviceDpName + ".model", deviceModel);
	else
	{
		fwException_raise(	exceptionInfo,
							"WARNING",
							"fwDevice_setModel: it is not possible to set a device model for the device " + deviceDpName,
							"");
	}
}


/** Sets a new value for a given element in the given device, and for all
of its children in the specified hierarchy if they have also that element.

@par Constraints
	None

@par Usage
	Public

@par PVSS managers
	VISION, CTRL

@param deviceDpName		dp name of the device (e.g. CAEN/crate003/board07/channel005)
@param element			element in the datapoint to be set
@param hierarchyType	hierarchy type, either fwDevice_HARDWARE or fwDevice_LOGICAL
@param value			value to be set
@param exceptionInfo	details of any exceptions
*/
fwDevice_setPropertyRecursively(string deviceDpName, string element, string hierarchyType, string value, dyn_string exceptionInfo)
{
	unsigned dpId;
	int elId;
	dyn_string children;

	//DebugTN("fwDevice_setPropertyRecursively(): Device " + deviceDpName + " element " + element +
			// " hierarchyType " + hierarchyType + " value " + value);

	// set the value for the given device
	if(dpGetId(deviceDpName + element, dpId, elId))
	{
		dpSet(deviceDpName + element, value);
		//	DebugN("Device " + children[i] + " has element " + element);
	}

	// set the value for all of its children
	fwDevice_getChildren(deviceDpName, hierarchyType, children, exceptionInfo);

	for(int i = 1; i <= dynlen(children); i++)
	{
		fwDevice_setPropertyRecursively(children[i], element, hierarchyType, value, exceptionInfo);
	}
}


/** Check if a string is a valid variable name
  @param name  the string to check
  @return true if it is a valid variable name
*/
bool fwDevice_isValidVariableName(string name) {
   name =strltrim(strrtrim(name," ")," ");
  char c;
  string type;
  for (int i=0; i< strlen(name); i++) {
      c= (char)substr(name,i,1);
      if ((c>= '0')  &&  (c<='9')) type = "digit";
      else if (((c>='a') && (c<='z')) ||  ((c>='A') && (c<='Z')) || (c=='_')) type="letter";
      else return false;
      if ((type == "digit")  && (i==0)) return false;
  }
  return true;
}


/**
  Assuming that the default values have been applied and that for each parameter there is an element set to {{parameter}} this function returns the
  mapping of replacements variable name = variable value for the given device

  @param deviceDpName the device to get the replacements
  @param exceptionInfo details of any exception
  @return mapping variable name to variable value
*/
mapping fwDevice_getReplacementsFromDp(string deviceDpName, dyn_string& exceptionInfo) {
	bool isDyn;
	int elType, result;
	string 	dpe, definitionDp;
	dyn_string defaultValues, dpes, dynValue ;

 anytype value;
 mapping m ;
 string var;

	fwDevice_getDefinitionDp(makeDynString(deviceDpName), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return m;

	result = dpGet(	definitionDp + ".properties.defaultValues", defaultValues,
					definitionDp + ".properties.dpes", dpes);

	for(int i = 1; i <= dynlen(defaultValues); i++)
	{
		if((defaultValues[i] != "") && (defaultValues[i] != fwDevice_DEFINITION_EMPTY_ENTRY))
		{
			dpe = deviceDpName + dpes[i];


   if (! ( (substr(defaultValues[i],0,2) == "{{") && (substr(defaultValues[i], strlen(defaultValues[i])-2,2) == "}}"))) continue; // only check simple default values of the form {{var}}
    var = substr(defaultValues[i],2,strlen(defaultValues[i])-4); // remove brackets
   if (! fwDevice_isValidVariableName(var) ) continue;

   if (mappingHasKey(m,var)) dynAppend(m[var], dpe);
   else m[var] = makeDynString(dpe);

		}
	}
 // process m - handle the case where the same expression is set in more than one dpe
 int index;
 for (int i=1; i<=mappinglen(m); i++) {
   var = mappingGetKey(m,i);
   dpes = m[var];
   if (dynlen(dpes) ==1) {
     index= 1;
   } else {
     bool dpFunctionExists;
     bool addressExists;
     dyn_mixed functionObj;
     dyn_anytype addressConf;
    bool isActive;
     index = 0;
     for (int j=1; j<= dynlen(dpes); j++) {
         // check if it has a dp function or an address
         fwDpFunction_objectGet(dpes[j], dpFunctionExists, functionObj, exceptionInfo);
         fwPeriphAddress_get(dpes[j], addressExists, addressConf, isActive, exceptionInfo);
        // DebugN(dpes[j], dpFunctionExists, addressExists);
         if ((! dpFunctionExists) && (! addressExists)) {
             index = j; break;
         }
     }
     if (index == 0) index = 1; // if all have function and address
   }
   dpe = dpes[index];
   elType = dpElementType(dpe);

	fwGeneral_isDpeTypeDyn(elType, isDyn, exceptionInfo);
   //DebugN("Getting parameter " + var +  " from " + dpe);
			if(isDyn)
			{
     dpGet(dpe, dynValue);
     m[var] = dynValue;
			}
			else
			{
				result = dpGet(dpe, value);
    m[var] = value;
			}

   }

	return m;
}

/** Sets the units for the dpes inside that have
a unit spedified in the device/model definition

@par Constraints
None

@par Usage
Public

@par PVSS managers
VISION, CTRL

@param deviceDpName dp name of the device (e.g. CAEN/crate003/board07/channel005)
@param exceptionInfo details of any exceptions

@reviewed 2018-06-22 @whitelisted{API} Even though it does not seem to be used,
          keep it as a part of public API
*/
fwDevice_setUnits(string deviceDpName, dyn_string &exceptionInfo)
{
	int resultInt;
	string definitionDp;
	dyn_bool canHaveUnits;
	dyn_string dpElements;
	dyn_langString units;
	dyn_errClass lastError;


	fwDevice_getDefinitionDp(makeDynString(deviceDpName), definitionDp, exceptionInfo);
	if(definitionDp == "")
		return;

	// get information from device definition
	resultInt = dpGet( 	definitionDp + fwDevice_ELEMENTS , 				dpElements,
						definitionDp + ".configuration.unit.canHave", 	canHaveUnits,
						definitionDp + ".configuration.unit.unit", 		units);

	if(resultInt < 0 )
	{
		lastError = getLastError();
		//DebugN("fwDevice_copy: ", lastError);
		fwException_raise(	exceptionInfo, "ERROR",
							"fwDevice_setUnits(): There were problems settings units for device " + deviceDpName + " Error text: " + getErrorText(lastError),
							resultInt);
	}

	for (int i = 1; i <= dynlen(dpElements); i++)
	{

		// Do some claen-up in case the definition doesn't include all the values
		if (dynlen(canHaveUnits) < i)
		{
			canHaveUnits[i] = false;
			units[i] = "";
		}

		if ((canHaveUnits[i]) && (strtoupper((string)units[i]) != fwDevice_DEFINITION_EMPTY_ENTRY) )
		{
			resultInt = dpSetUnit(deviceDpName + dpElements[i], units[i]);

			if(resultInt < 0 )
			{
				lastError = getLastError();
				//DebugN("fwDevice_copy: ", lastError);
				fwException_raise(	exceptionInfo, "ERROR",
									"fwDevice_setUnits(): There were problems settings units for device " + deviceDpName + " Error text: " + getErrorText(lastError),
									resultInt);
			}
		}
	}
}
//@}
