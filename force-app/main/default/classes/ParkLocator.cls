public class ParkLocator{
    public static List<String> country(String count) {
        ParkService.ParksImplPort parks = new ParkService.ParksImplPort();
        return parks.byCountry(count);
    }
}
